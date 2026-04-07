//
//  FirebaseUserProfileService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class FirebaseUserProfileService: UserProfileRepository {
    private let imageService: ImageUploader
    private let usersCollection = Firestore.firestore().collection("users")

    init(imageService: ImageUploader) {
        self.imageService = imageService
    }

    func fetchCurrentUser() -> AnyPublisher<UserProfileUser, Error> {
        guard let authUser = Auth.auth().currentUser else {
            return Fail(error: UserProfileRepositoryError.missingCurrentUser)
                .eraseToAnyPublisher()
        }

        return userDocumentPublisher(for: authUser)
            .map { [weak self] document in
                guard let self else {
                    return UserProfileUser(
                        id: authUser.uid,
                        firstName: "",
                        lastName: "",
                        email: authUser.email,
                        avatarURLString: authUser.photoURL?.absoluteString
                    )
                }
                return self.makeProfile(from: authUser, document: document)
            }
            .eraseToAnyPublisher()
    }

    func save(user: UserProfileUser, selectedPhoto: Data?) -> AnyPublisher<UserProfileUser, Error> {
        guard let selectedPhoto else {
            return saveUser(user)
        }

        return imageService
            .uploadImage(
                data: selectedPhoto,
                resource: UploadImageResource.user(id: user.id)
            )
            .flatMap { [weak self] url -> AnyPublisher<UserProfileUser, Error> in
                guard let self else {
                    return Fail(error: UserProfileRepositoryError.repositoryDeallocated)
                        .eraseToAnyPublisher()
                }

                let updatedUser = UserProfileUser(
                    id: user.id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    email: user.email,
                    avatarURLString: url.absoluteString
                )

                return self.saveUser(updatedUser)
            }
            .eraseToAnyPublisher()
    }

    func signOut() -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    private func userDocumentPublisher(for authUser: User) -> AnyPublisher<UserProfileDocument, Error> {
        Future { [usersCollection] promise in
            usersCollection.document(authUser.uid).getDocument { snapshot, error in
                if let error {
                    promise(.failure(error))
                    return
                }

                let document = UserProfileDocument(snapshotData: snapshot?.data())
                promise(.success(document))
            }
        }
        .eraseToAnyPublisher()
    }

    private func saveUser(_ user: UserProfileUser) -> AnyPublisher<UserProfileUser, Error> {
        updateAuthProfile(for: user)
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail(error: UserProfileRepositoryError.repositoryDeallocated)
                        .eraseToAnyPublisher()
                }

                return self.saveUserDocument(user)
            }
            .map { user }
            .eraseToAnyPublisher()
    }

    private func updateAuthProfile(for user: UserProfileUser) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let authUser = Auth.auth().currentUser else {
                promise(.failure(UserProfileRepositoryError.missingCurrentUser))
                return
            }

            let changeRequest = authUser.createProfileChangeRequest()
            changeRequest.displayName = user.displayName
            changeRequest.photoURL = user.avatarURL
            changeRequest.commitChanges { error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func saveUserDocument(_ user: UserProfileUser) -> AnyPublisher<Void, Error> {
        Future { [usersCollection] promise in
            let document = UserProfileDocument(
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                photoURLString: user.avatarURLString
            )

            usersCollection.document(user.id).setData(document.firestoreData, merge: true) { error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func makeProfile(from authUser: User, document: UserProfileDocument) -> UserProfileUser {
        let fallbackNames = Self.splitDisplayName(authUser.displayName)
        let firstName = document.firstName ?? fallbackNames.firstName
        let lastName = document.lastName ?? fallbackNames.lastName
        let email = document.email ?? authUser.email
        let avatarURLString = document.photoURLString ?? authUser.photoURL?.absoluteString

        return UserProfileUser(
            id: authUser.uid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            avatarURLString: avatarURLString
        )
    }

    private static func splitDisplayName(_ displayName: String?) -> (firstName: String, lastName: String) {
        let trimmed = displayName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty else { return ("", "") }

        let parts = trimmed
            .split(separator: " ")
            .map(String.init)

        guard let first = parts.first else { return ("", "") }
        let last = parts.dropFirst().joined(separator: " ")
        return (first, last)
    }
}

private struct UserProfileDocument {
    let firstName: String?
    let lastName: String?
    let email: String?
    let photoURLString: String?

    init(
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        photoURLString: String? = nil
    ) {
        self.firstName = firstName?.nilIfBlank
        self.lastName = lastName?.nilIfBlank
        self.email = email?.nilIfBlank
        self.photoURLString = photoURLString?.nilIfBlank
    }

    init(snapshotData: [String: Any]?) {
        self.firstName = (snapshotData?["first_name"] as? String)?.nilIfBlank
        self.lastName = (snapshotData?["last_name"] as? String)?.nilIfBlank
        self.email = (snapshotData?["email"] as? String)?.nilIfBlank
        self.photoURLString = (snapshotData?["photo_url"] as? String)?.nilIfBlank
    }

    var fullName: String {
        [firstName, lastName]
            .compactMap { $0?.nilIfBlank }
            .joined(separator: " ")
    }

    var firestoreData: [String: Any] {
        [
            "first_name": firstName ?? "",
            "last_name": lastName ?? "",
            "email": email ?? "",
            "photo_url": photoURLString ?? ""
        ]
    }
}

private enum UserProfileRepositoryError: LocalizedError {
    case missingCurrentUser
    case repositoryDeallocated

    var errorDescription: String? {
        switch self {
        case .missingCurrentUser:
            return NSLocalizedString("error.common.try_again", comment: "")
        case .repositoryDeallocated:
            return NSLocalizedString("error.common.try_again", comment: "")
        }
    }
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
