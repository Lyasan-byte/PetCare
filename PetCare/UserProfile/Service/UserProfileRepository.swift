//
//  UserProfileRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Foundation
import Combine

protocol UserProfileRepository {
    func fetchCurrentUser() -> AnyPublisher<UserProfileUser, Error>
    func signOut() -> AnyPublisher<Void, Error>
}
