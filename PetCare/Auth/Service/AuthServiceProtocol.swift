//
//  AuthServiceProtocol.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 25.03.2026.
//

import Foundation
import UIKit

protocol AuthServiceProtocol {
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void)
}
