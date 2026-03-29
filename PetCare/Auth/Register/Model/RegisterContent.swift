//
//  RegisterContent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation

struct RegisterContent {
    let title: String
    let subtitle: String
    let email: String
    let password: String
    let isRegisterEnabled: Bool
    let isLoading: Bool
}

typealias RegisterState = ViewState<RegisterContent>
