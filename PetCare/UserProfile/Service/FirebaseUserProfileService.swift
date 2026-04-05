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
    private let usersCollection = Firestore.firestore().collection("users")

    init() {}

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

    var errorDescription: String? {
        switch self {
        case .missingCurrentUser:
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
