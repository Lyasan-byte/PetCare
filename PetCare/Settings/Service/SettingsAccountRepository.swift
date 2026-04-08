//
//  SettingsAccountRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Combine
import UIKit

protocol SettingsAccountRepository {
    func deleteCurrentAccount(presentingViewController: UIViewController) -> AnyPublisher<Void, Error>
}
