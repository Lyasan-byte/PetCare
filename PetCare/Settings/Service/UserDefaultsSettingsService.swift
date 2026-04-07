//
//  UserDefaultsSettingsService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

final class UserDefaultsSettingsService: SettingsRepository {
    private enum Keys {
        static let isNotificationsEnabled = "settings.notifications.enabled"
        static let isGroomingEnabled = "settings.notifications.grooming"
        static let isVeterinarianEnabled = "settings.notifications.veterinarian"
        static let isGeneralRemindersEnabled = "settings.notifications.generalReminders"
        static let theme = "settings.appearance.theme"
        static let language = "settings.appearance.language"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadSettings() -> SettingsState {
        var settings = SettingsState.defaultValue

        if userDefaults.object(forKey: Keys.isNotificationsEnabled) != nil {
            settings.isNotificationsEnabled = userDefaults.bool(forKey: Keys.isNotificationsEnabled)
        }
        if userDefaults.object(forKey: Keys.isGroomingEnabled) != nil {
            settings.isGroomingEnabled = userDefaults.bool(forKey: Keys.isGroomingEnabled)
        }
        if userDefaults.object(forKey: Keys.isVeterinarianEnabled) != nil {
            settings.isVeterinarianEnabled = userDefaults.bool(forKey: Keys.isVeterinarianEnabled)
        }
        if userDefaults.object(forKey: Keys.isGeneralRemindersEnabled) != nil {
            settings.isGeneralRemindersEnabled = userDefaults.bool(forKey: Keys.isGeneralRemindersEnabled)
        }

        if let themeRawValue = userDefaults.string(forKey: Keys.theme),
           let theme = SettingsTheme(rawValue: themeRawValue) {
            settings.theme = theme
        }

        if let languageRawValue = userDefaults.string(forKey: Keys.language),
           let language = SettingsLanguage(rawValue: languageRawValue) {
            settings.language = language
        }

        if !settings.isNotificationsEnabled {
            settings.isGroomingEnabled = false
            settings.isVeterinarianEnabled = false
            settings.isGeneralRemindersEnabled = false
        }

        return settings
    }

    func save(settings: SettingsState) {
        userDefaults.set(settings.isNotificationsEnabled, forKey: Keys.isNotificationsEnabled)
        userDefaults.set(settings.isGroomingEnabled, forKey: Keys.isGroomingEnabled)
        userDefaults.set(settings.isVeterinarianEnabled, forKey: Keys.isVeterinarianEnabled)
        userDefaults.set(settings.isGeneralRemindersEnabled, forKey: Keys.isGeneralRemindersEnabled)
        userDefaults.set(settings.theme.rawValue, forKey: Keys.theme)
        userDefaults.set(settings.language.rawValue, forKey: Keys.language)
    }
}
