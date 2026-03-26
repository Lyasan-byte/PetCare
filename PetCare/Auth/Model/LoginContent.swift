//
//  LoginContent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation

struct LoginContent {
    let title: String
    let subtitle: String
    let email: String
    let password: String
    let isLoginEnabled: Bool
    let isLoading: Bool
}

typealias LoginState = ViewState<LoginContent>
