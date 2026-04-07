//
//  FirebaseSettingsAccountService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import UIKit

final class FirebaseSettingsAccountService: SettingsAccountRepository {
    private let auth: Auth
    private let firestore: Firestore
    private let petsCollection: CollectionReference
    private let usersCollection: CollectionReference
    private let googleSignInService: GoogleSignInService

    init(
        auth: Auth = .auth(),
        firestore: Firestore = .firestore(),
        googleSignInService: GoogleSignInService = GoogleSignInService()
    ) {
        self.auth = auth
        self.firestore = firestore
        self.petsCollection = firestore.collection("pets")
        self.usersCollection = firestore.collection("users")
        self.googleSignInService = googleSignInService
    }

    func deleteCurrentAccount(presentingViewController: UIViewController) -> AnyPublisher<Void, Error> {
        guard let user = auth.currentUser else {
            return Fail(error: SettingsAccountDeletionError.missingCurrentUser)
                .eraseToAnyPublisher()
        }

        let userId = user.uid

        return ensureDeletionAuthorization(
                for: user,
                presentingViewController: presentingViewController
            )
            .flatMap { [weak self] in
                self?.fetchPetDocumentReferences(ownerId: userId) ??
                    Fail(error: SettingsAccountDeletionError.serviceUnavailable).eraseToAnyPublisher()
            }
            .flatMap { [weak self] petReferences in
                self?.deleteFirestoreData(userId: userId, petReferences: petReferences) ??
                    Fail(error: SettingsAccountDeletionError.serviceUnavailable).eraseToAnyPublisher()
            }
            .flatMap { [weak self] in
                self?.deleteAuthUser(user) ??
                    Fail(error: SettingsAccountDeletionError.serviceUnavailable).eraseToAnyPublisher()
            }
            .flatMap { [weak self] in
                self?.revokeGoogleAccessIfNeeded(for: user) ??
                    Fail(error: SettingsAccountDeletionError.serviceUnavailable).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func ensureDeletionAuthorization(
        for user: User,
        presentingViewController: UIViewController
    ) -> AnyPublisher<Void, Error> {
        validateRecentSignIn(for: user)
            .catch { [weak self] error -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail(error: SettingsAccountDeletionError.serviceUnavailable)
                        .eraseToAnyPublisher()
                }

                guard self.isGoogleAccount(user), Self.requiresRecentLogin(error) else {
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                return self.googleSignInService
                    .reauthenticateCurrentUser(presentingViewController: presentingViewController)
                    .mapError { reauthError in
                        Self.mapDeletionError(reauthError)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func validateRecentSignIn(for user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            let threshold: TimeInterval = 5 * 60
            let lastSignInDate = user.metadata.lastSignInDate ?? .distantPast
            let isRecent = abs(lastSignInDate.timeIntervalSinceNow) <= threshold

            if isRecent {
                promise(.success(()))
            } else {
                promise(.failure(SettingsAccountDeletionError.requiresRecentLogin))
            }
        }
        .eraseToAnyPublisher()
    }

    private func revokeGoogleAccessIfNeeded(for user: User) -> AnyPublisher<Void, Error> {
        guard isGoogleAccount(user) else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return googleSignInService
            .revokeAccess()
            .mapError { error in
                Self.mapDeletionError(error)
            }
            .eraseToAnyPublisher()
    }

    private func isGoogleAccount(_ user: User) -> Bool {
        user.providerData.contains { $0.providerID == "google.com" }
    }

    private func fetchPetDocumentReferences(ownerId: String) -> AnyPublisher<[DocumentReference], Error> {
        Future { [petsCollection] promise in
            petsCollection
                .whereField(Pet.CodingKeys.ownerId.rawValue, isEqualTo: ownerId)
                .getDocuments { snapshot, error in
                    if let error {
                        promise(.failure(error))
                        return
                    }

                    let references = snapshot?.documents.map(\.reference) ?? []
                    promise(.success(references))
                }
        }
        .eraseToAnyPublisher()
    }

    private func deleteFirestoreData(
        userId: String,
        petReferences: [DocumentReference]
    ) -> AnyPublisher<Void, Error> {
        Future { [firestore, usersCollection] promise in
            let batch = firestore.batch()
            for ref in petReferences {
                batch.deleteDocument(ref)
            }
            batch.deleteDocument(usersCollection.document(userId))

            batch.commit { error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func deleteAuthUser(_ user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            user.delete { error in
                if let nsError = error as NSError? {
                    if AuthErrorCode(rawValue: nsError.code) == .requiresRecentLogin {
                        promise(.failure(SettingsAccountDeletionError.requiresRecentLogin))
                    } else {
                        promise(.failure(nsError))
                    }
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private static func mapDeletionError(_ error: Error) -> Error {
        let nsError = error as NSError
        if nsError.domain == AuthErrorDomain,
           AuthErrorCode(rawValue: nsError.code) == .requiresRecentLogin {
            return SettingsAccountDeletionError.requiresRecentLogin
        }

        return error
    }

    private static func requiresRecentLogin(_ error: Error) -> Bool {
        if let deletionError = error as? SettingsAccountDeletionError {
            switch deletionError {
            case .requiresRecentLogin:
                return true
            case .missingCurrentUser, .serviceUnavailable:
                return false
            }
        }

        let nsError = error as NSError
        return nsError.domain == AuthErrorDomain &&
            AuthErrorCode(rawValue: nsError.code) == .requiresRecentLogin
    }
}

private enum SettingsAccountDeletionError: LocalizedError {
    case missingCurrentUser
    case requiresRecentLogin
    case serviceUnavailable

    var errorDescription: String? {
        switch self {
        case .missingCurrentUser, .serviceUnavailable:
            return NSLocalizedString("error.common.try_again", comment: "")
        case .requiresRecentLogin:
            return NSLocalizedString("settings.account.delete.reauth", comment: "")
        }
    }
}
