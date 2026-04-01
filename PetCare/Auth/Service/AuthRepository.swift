//
//  AuthRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import Combine
import UIKit

protocol AuthRepository {
    func signIn(email: String, password: String) -> AnyPublisher<Void, Error>
    func register(email: String, password: String) -> AnyPublisher<Void, Error>
    func signInWithGoogle(presentingViewController: UIViewController) -> AnyPublisher<Void, Error>
}
