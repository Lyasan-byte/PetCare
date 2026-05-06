//
//  SettingsLanguage.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

enum SettingsLanguage: String, CaseIterable {
    case russian = "ru"
    case english = "en"

    static var defaultValue: SettingsLanguage {
        let preferredLanguage = Locale.preferredLanguages.first ?? ""
        return preferredLanguage.lowercased().hasPrefix(Self.russian.rawValue) ? .russian : .english
    }

    static var current: SettingsLanguage {
        let rawValue = UserDefaults.standard.string(forKey: "settings.appearance.language")

        if let rawValue, let language = SettingsLanguage(rawValue: rawValue) {
            return language
        }

        return defaultValue
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var localizedTitle: String {
        switch self {
        case .russian:
            NSLocalizedString("settings.appearance.language.russian", comment: "")
        case .english:
            NSLocalizedString("settings.appearance.language.english", comment: "")
        }
    }
}
