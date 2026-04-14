//
//  SettingsIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

enum SettingsIntent {
    case backTapped
    case allNotificationsToggled(Bool)
    case walkToggled(Bool)
    case groomingToggled(Bool)
    case veterinarianToggled(Bool)
    case themeSelected(SettingsTheme)
    case languageSelected(SettingsLanguage)
    case deleteAccountTapped
    case confirmDeleteAccount
    case dismissAlert
}
