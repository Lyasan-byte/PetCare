//
//  SettingsState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

struct SettingsState {
    var isNotificationsEnabled: Bool
    var isGroomingEnabled: Bool
    var isVeterinarianEnabled: Bool
    var isGeneralRemindersEnabled: Bool
    var theme: SettingsTheme
    var language: SettingsLanguage
    var isDeletingAccount: Bool
    var errorMessage: String?
    var isDeleteConfirmationPresented: Bool

    static let defaultValue = SettingsState(
        isNotificationsEnabled: true,
        isGroomingEnabled: true,
        isVeterinarianEnabled: true,
        isGeneralRemindersEnabled: false,
        theme: .light,
        language: .defaultValue,
        isDeletingAccount: false,
        errorMessage: nil,
        isDeleteConfirmationPresented: false
    )
}
