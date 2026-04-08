//
//  SettingsViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import Combine
import UIKit

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
    @Published private(set) var state: SettingsState = .loading {
        didSet {
            stateDidChange.send()
        }
    }

    private let settingsRepository: SettingsRepository
    private let settingsApplicationController: SettingsApplicationControlling
    private let accountRepository: SettingsAccountRepository
    private weak var moduleOutput: SettingsModuleOutput?
    private var bag = Set<AnyCancellable>()
    private var displayData: SettingsDisplayData
    private var savedPreferences = NotificationPreferences(
        grooming: true,
        veterinarian: true,
        generalReminders: false
    )

    init(
        settingsRepository: SettingsRepository,
        settingsApplicationController: SettingsApplicationControlling,
        accountRepository: SettingsAccountRepository,
        moduleOutput: SettingsModuleOutput?
    ) {
        self.settingsRepository = settingsRepository
        self.settingsApplicationController = settingsApplicationController
        self.accountRepository = accountRepository
        self.moduleOutput = moduleOutput
        let storedDisplayData = settingsRepository.loadSettings()
        self.displayData = storedDisplayData
        state = .content(storedDisplayData)

        if storedDisplayData.isNotificationsEnabled {
            savedPreferences = NotificationPreferences(
                grooming: storedDisplayData.isGroomingEnabled,
                veterinarian: storedDisplayData.isVeterinarianEnabled,
                generalReminders: storedDisplayData.isGeneralRemindersEnabled
            )
        }
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
                veterinarian: displayData.isVeterinarianEnabled,
                generalReminders: displayData.isGeneralRemindersEnabled
            )
        case .veterinarianToggled(let isEnabled):
            updateNotificationPreferences(
                grooming: displayData.isGroomingEnabled,
                veterinarian: isEnabled,
                generalReminders: displayData.isGeneralRemindersEnabled
            )
        case .generalRemindersToggled(let isEnabled):
            updateNotificationPreferences(
                grooming: displayData.isGroomingEnabled,
                veterinarian: displayData.isVeterinarianEnabled,
                generalReminders: isEnabled
            )
        case .themeSelected(let theme):
            updateTheme(theme)
        case .languageSelected(let language):
            updateLanguage(language)
        case .deleteAccountTapped:
            displayData.isDeleteConfirmationPresented = true
            state = .content(displayData)
        case .confirmDeleteAccount:
            displayData.isDeleteConfirmationPresented = false
            state = .content(displayData)
            deleteAccount()
        case .dismissAlert:
            displayData.isDeleteConfirmationPresented = false
            state = .content(displayData)
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
                grooming: displayData.isGroomingEnabled,
                veterinarian: displayData.isVeterinarianEnabled,
                generalReminders: displayData.isGeneralRemindersEnabled
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
        displayData.isNotificationsEnabled = preferences.hasEnabledNotifications
        displayData.isGroomingEnabled = preferences.grooming
        displayData.isVeterinarianEnabled = preferences.veterinarian
        displayData.isGeneralRemindersEnabled = preferences.generalReminders
        state = .content(displayData)
        persistSettings()
    }

    private func updateTheme(_ theme: SettingsTheme) {
        guard displayData.theme != theme else { return }
        displayData.theme = theme
        state = .content(displayData)
        persistSettings()
        settingsApplicationController.applyTheme(theme)
    }

    private func updateLanguage(_ language: SettingsLanguage) {
        guard displayData.language != language else { return }
        displayData.language = language
        state = .content(displayData)
        persistSettings()
        settingsApplicationController.applyLanguage(language)
    }

    private func persistSettings() {
        settingsRepository.save(settings: displayData)
    }

    private func deleteAccount() {
        guard !displayData.isDeletingAccount else { return }
        guard let presentingViewController = moduleOutput?.provideViewControllerForAccountDeletion() else {
            state = .error(NSLocalizedString("error.common.try_again", comment: ""))
            return
        }

        displayData.isDeletingAccount = true
        state = .content(displayData)

        accountRepository.deleteCurrentAccount(presentingViewController: presentingViewController)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.displayData.isDeletingAccount = false

                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { _ in
            }
            .store(in: &bag)
    }
}
