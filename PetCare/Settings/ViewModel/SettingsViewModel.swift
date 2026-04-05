//
//  SettingsViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import Combine

final class SettingsViewModel: SettingsViewModeling {
    private struct NotificationPreferences {
        let grooming: Bool
        let veterinarian: Bool
        let generalReminders: Bool

        var hasEnabledNotifications: Bool {
            grooming || veterinarian || generalReminders
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()
    @Published private(set) var state = SettingsState.initial {
        didSet {
            stateDidChange.send()
        }
    }

    private weak var moduleOutput: SettingsModuleOutput?
    private var savedPreferences = NotificationPreferences(
        grooming: true,
        veterinarian: true,
        generalReminders: false
    )

    init(moduleOutput: SettingsModuleOutput?) {
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: SettingsIntent) {
        switch intent {
        case .backTapped:
            moduleOutput?.settingsModuleDidClose()
        case .allNotificationsToggled(let isEnabled):
            updateAllNotifications(isEnabled)
        case .groomingToggled(let isEnabled):
            updateNotificationPreferences(
                grooming: isEnabled,
                veterinarian: state.isVeterinarianEnabled,
                generalReminders: state.isGeneralRemindersEnabled
            )
        case .veterinarianToggled(let isEnabled):
            updateNotificationPreferences(
                grooming: state.isGroomingEnabled,
                veterinarian: isEnabled,
                generalReminders: state.isGeneralRemindersEnabled
            )
        case .generalRemindersToggled(let isEnabled):
            updateNotificationPreferences(
                grooming: state.isGroomingEnabled,
                veterinarian: state.isVeterinarianEnabled,
                generalReminders: isEnabled
            )
        }
    }

    private func updateAllNotifications(_ isEnabled: Bool) {
        if isEnabled {
            let preferences = savedPreferences.hasEnabledNotifications
                ? savedPreferences
                : NotificationPreferences(grooming: true, veterinarian: true, generalReminders: false)
            apply(preferences)
        } else {
            savedPreferences = NotificationPreferences(
                grooming: state.isGroomingEnabled,
                veterinarian: state.isVeterinarianEnabled,
                generalReminders: state.isGeneralRemindersEnabled
            )
            apply(
                NotificationPreferences(
                    grooming: false,
                    veterinarian: false,
                    generalReminders: false
                )
            )
        }
    }

    private func updateNotificationPreferences(
        grooming: Bool,
        veterinarian: Bool,
        generalReminders: Bool
    ) {
        let preferences = NotificationPreferences(
            grooming: grooming,
            veterinarian: veterinarian,
            generalReminders: generalReminders
        )

        if preferences.hasEnabledNotifications {
            savedPreferences = preferences
        }

        apply(preferences)
    }

    private func apply(_ preferences: NotificationPreferences) {
        state = SettingsState(
            isNotificationsEnabled: preferences.hasEnabledNotifications,
            isGroomingEnabled: preferences.grooming,
            isVeterinarianEnabled: preferences.veterinarian,
            isGeneralRemindersEnabled: preferences.generalReminders
        )
    }
}
