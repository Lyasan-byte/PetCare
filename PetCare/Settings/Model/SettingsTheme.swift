//
//  SettingsTheme.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

enum SettingsTheme: String, CaseIterable {
    case light
    case dark

    var localizedTitle: String {
        switch self {
        case .light:
            NSLocalizedString("settings.appearance.theme.light", comment: "")
        case .dark:
            NSLocalizedString("settings.appearance.theme.dark", comment: "")
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}
