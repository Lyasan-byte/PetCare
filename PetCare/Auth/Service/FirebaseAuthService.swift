//
//  FirebaseAuthService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation
import FirebaseAuth
import Combine
import UIKit

final class FirebaseAuthService: AuthRepository {

    private let googleSignInService: GoogleSignInService

    init(googleSignInService: GoogleSignInService = GoogleSignInService()) {
        self.googleSignInService = googleSignInService
    }

    func signIn(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func register(email: String, password: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func signInWithGoogle(presentingViewController: UIViewController) -> AnyPublisher<Void, Error> {
        googleSignInService.signIn(presentingViewController: presentingViewController)
    }
}
