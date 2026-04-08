//
//  GoogleSignInService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import Combine

final class GoogleSignInService {
    private let usersCollection = Firestore.firestore().collection("users")

    func signIn(
        presentingViewController: UIViewController
    ) -> AnyPublisher<Void, Error> {
        authenticateWithGoogle(presentingViewController: presentingViewController)
            .flatMap { credential in
                Future<User, Error> { promise in
                    Auth.auth().signIn(with: credential) { authResult, error in
                        if let error {
                            promise(.failure(error))
                        } else if let user = authResult?.user {
                            promise(.success(user))
                        } else {
                            promise(.failure(NSError(
                                domain: "GoogleSignInService",
                                code: -4,
                                userInfo: [
                                    NSLocalizedDescriptionKey: NSLocalizedString("error.common.try_again", comment: "")
                                ]
                            )))
                        }
                    }
                }
            }
            .flatMap { [weak self] user -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail(error: NSError(
                        domain: "GoogleSignInService",
                        code: -5,
                        userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("error.common.try_again", comment: "")]
                    ))
                    .eraseToAnyPublisher()
                }

                return self.ensureUserProfileDocumentExists(for: user)
            }
            .eraseToAnyPublisher()
    }

    func reauthenticateCurrentUser(
        presentingViewController: UIViewController
    ) -> AnyPublisher<Void, Error> {
        authenticateWithGoogle(presentingViewController: presentingViewController)
            .flatMap { credential in
                Future { promise in
                    guard let currentUser = Auth.auth().currentUser else {
                        promise(.failure(NSError(
                            domain: "GoogleSignInService",
                            code: -3,
                            userInfo: [
                                NSLocalizedDescriptionKey: NSLocalizedString("error.common.try_again", comment: "")
                            ]
                        )))
                        return
                    }

                    currentUser.reauthenticate(with: credential) { _, error in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    func revokeAccess() -> AnyPublisher<Void, Error> {
        Future { promise in
            GIDSignIn.sharedInstance.disconnect { error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func authenticateWithGoogle(
        presentingViewController: UIViewController
    ) -> AnyPublisher<AuthCredential, Error> {
        Future { promise in
            do {
                try self.configureGoogleSignIn()
            } catch {
                promise(.failure(error))
                return
            }

            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                if let error {
                    promise(.failure(error))
                    return
                }

                guard let credential = self.makeCredential(from: result?.user) else {
                    promise(.failure(NSError(
                        domain: "GoogleSignInService",
                        code: -2,
                        userInfo: [
                            NSLocalizedDescriptionKey: NSLocalizedString("error.google.token.missing", comment: "")
                        ]
                    )))
                    return
                }

                promise(.success(credential))
            }
        }
        .eraseToAnyPublisher()
    }

    private func configureGoogleSignIn() throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(
                domain: "GoogleSignInService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("error.google.clientId.missing", comment: "")]
            )
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
    }

    private func makeCredential(from user: GIDGoogleUser?) -> AuthCredential? {
        guard
            let user,
            let idToken = user.idToken?.tokenString
        else {
            return nil
        }

        return GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
    }

    private func ensureUserProfileDocumentExists(for user: User) -> AnyPublisher<Void, Error> {
        Future { [usersCollection] promise in
            let documentRef = usersCollection.document(user.uid)

            documentRef.getDocument { snapshot, error in
                if let error {
                    promise(.failure(error))
                    return
                }

                if snapshot?.exists == true {
                    promise(.success(()))
                    return
                }

                let nameParts = Self.splitDisplayName(user.displayName)
                let data: [String: Any] = [
                    "first_name": nameParts.firstName,
                    "last_name": nameParts.lastName,
                    "email": user.email ?? "",
                    "photo_url": user.photoURL?.absoluteString ?? ""
                ]

                documentRef.setData(data, merge: true) { error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private static func splitDisplayName(_ displayName: String?) -> (firstName: String, lastName: String) {
        let trimmed = displayName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty else { return ("", "") }

        let parts = trimmed
            .split(separator: " ")
            .map(String.init)

        guard let firstName = parts.first else { return ("", "") }
        let lastName = parts.dropFirst().joined(separator: " ")
        return (firstName, lastName)
    }
}
