//
//  SettingsState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

struct SettingsDisplayData {
    var isNotificationsEnabled: Bool
    var isGroomingEnabled: Bool
    var isVeterinarianEnabled: Bool
    var isGeneralRemindersEnabled: Bool
    var theme: SettingsTheme
    var language: SettingsLanguage
    var isDeletingAccount: Bool
    var isDeleteConfirmationPresented: Bool

    static let defaultValue = SettingsDisplayData(
        isNotificationsEnabled: true,
        isGroomingEnabled: true,
        isVeterinarianEnabled: true,
        isGeneralRemindersEnabled: false,
        theme: .light,
        language: .defaultValue,
        isDeletingAccount: false,
        isDeleteConfirmationPresented: false
    )
}

enum SettingsState {
    case loading
    case content(SettingsDisplayData)
    case error(String)
}
