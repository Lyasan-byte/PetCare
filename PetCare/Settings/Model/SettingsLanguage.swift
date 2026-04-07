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

    var localizedTitle: String {
        switch self {
        case .russian:
            NSLocalizedString("settings.appearance.language.russian", comment: "")
        case .english:
            NSLocalizedString("settings.appearance.language.english", comment: "")
        }
    }
}
