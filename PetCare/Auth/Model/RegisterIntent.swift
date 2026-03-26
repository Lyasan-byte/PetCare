//
//  RegisterIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation

enum RegisterIntent {
    case onDidLoad
    case emailChanged(String)
    case passwordChanged(String)
    case confirmPasswordChanged(String)
    case registerTapped
    case googleTapped
    case loginTapped
}
