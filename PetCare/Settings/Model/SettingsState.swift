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

    static let initial = SettingsState(
        isNotificationsEnabled: true,
        isGroomingEnabled: true,
        isVeterinarianEnabled: true,
        isGeneralRemindersEnabled: false
    )
}
