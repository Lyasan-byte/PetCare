//
//  SettingsApplicationController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit
import ObjectiveC.runtime

protocol SettingsApplicationControlling {
    func applyTheme(_ theme: SettingsTheme)
    func applyLanguage(_ language: SettingsLanguage)
}

extension Notification.Name {
    static let settingsLanguageDidChange = Notification.Name("settingsLanguageDidChange")
}

final class SettingsApplicationController: SettingsApplicationControlling {
    func applyTheme(_ theme: SettingsTheme) {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)

        windows.forEach { window in
            window.overrideUserInterfaceStyle = theme.interfaceStyle
        }
    }

    func applyLanguage(_ language: SettingsLanguage) {
        Bundle.setApplicationLanguage(language.rawValue)
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        NotificationCenter.default.post(name: .settingsLanguageDidChange, object: language)
    }
}

private var localizedBundleKey: UInt8 = 0

private final class SettingsLocalizedBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &localizedBundleKey) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }

        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

private extension Bundle {
    static func setApplicationLanguage(_ identifier: String) {
        let bundle = Bundle.main.path(forResource: identifier, ofType: "lproj").flatMap(Bundle.init(path:)) ?? .main
        object_setClass(Bundle.main, SettingsLocalizedBundle.self)
        objc_setAssociatedObject(Bundle.main, &localizedBundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
