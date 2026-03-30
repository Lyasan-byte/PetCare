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
import GoogleSignIn

final class GoogleSignInService {

    func signIn(
        presentingViewController: UIViewController,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(
                domain: "GoogleSignInService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("error.google.clientId.missing", comment: "")]
            )))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                completion(.failure(NSError(
                    domain: "GoogleSignInService",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("error.google.token.missing", comment: "")]
                )))
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}

