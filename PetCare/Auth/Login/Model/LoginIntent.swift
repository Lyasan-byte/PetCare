//
//  LoginIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation

enum LoginIntent {
    case onDidLoad
    case emailChanged(String)
    case passwordChanged(String)
    case loginTapped
    case googleTapped
    case registerTapped
    case helpTapped
}
