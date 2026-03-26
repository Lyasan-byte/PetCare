//
//  FirebaseAuthService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation
import UIKit
import FirebaseAuth

final class FirebaseAuthService: AuthServiceProtocol {

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        GoogleSignInService().signIn(presentingViewController: presentingViewController, completion: completion)
    }
}
