//
//  UserRepository.swift
//  PetCare
//
//  Created by Ляйсан on 7/4/26.
//

import Foundation
import Combine

protocol UserRepository {
    func fetchUser(for id: String) -> AnyPublisher<UserProfileUser, Error>
}
