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
        let walk: Bool
        let grooming: Bool
        let veterinarian: Bool

        var hasEnabledNotifications: Bool {
            walk || grooming || veterinarian
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
    private let reminderController: PetActivityReminderControlling
    private weak var moduleOutput: SettingsModuleOutput?
    private var bag = Set<AnyCancellable>()
    private var displayData: SettingsDisplayData
    private var savedPreferences = NotificationPreferences(
        walk: true,
        grooming: true,
        veterinarian: true
    )

    init(
        settingsRepository: SettingsRepository,
        settingsApplicationController: SettingsApplicationControlling,
        accountRepository: SettingsAccountRepository,
        reminderController: PetActivityReminderControlling,
        moduleOutput: SettingsModuleOutput?
    ) {
        self.settingsRepository = settingsRepository
        self.settingsApplicationController = settingsApplicationController
        self.accountRepository = accountRepository
        self.reminderController = reminderController
        self.moduleOutput = moduleOutput
        let storedDisplayData = settingsRepository.loadSettings()
        self.displayData = storedDisplayData
        state = .content(storedDisplayData)

        if storedDisplayData.isNotificationsEnabled {
            savedPreferences = NotificationPreferences(
                walk: storedDisplayData.isWalkEnabled,
                grooming: storedDisplayData.isGroomingEnabled,
                veterinarian: storedDisplayData.isVeterinarianEnabled
            )
        }
    }

    func trigger(_ intent: SettingsIntent) {
        switch intent {
        case .backTapped:
            moduleOutput?.settingsModuleDidClose()
        case .allNotificationsToggled(let isEnabled):
            updateAllNotifications(isEnabled)
        case .walkToggled(let isEnabled):
            updateNotificationPreferences(
                walk: isEnabled,
                grooming: displayData.isGroomingEnabled,
                veterinarian: displayData.isVeterinarianEnabled
            )
        case .groomingToggled(let isEnabled):
            updateNotificationPreferences(
                walk: displayData.isWalkEnabled,
                grooming: isEnabled,
                veterinarian: displayData.isVeterinarianEnabled
            )
        case .veterinarianToggled(let isEnabled):
            updateNotificationPreferences(
                walk: displayData.isWalkEnabled,
                grooming: displayData.isGroomingEnabled,
                veterinarian: isEnabled
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
                : NotificationPreferences(walk: true, grooming: true, veterinarian: true)
            apply(preferences)
        } else {
            savedPreferences = NotificationPreferences(
                walk: displayData.isWalkEnabled,
                grooming: displayData.isGroomingEnabled,
                veterinarian: displayData.isVeterinarianEnabled
            )
            apply(
                NotificationPreferences(
                    walk: false,
                    grooming: false,
                    veterinarian: false
                )
            )
        }
    }

    private func updateNotificationPreferences(
        walk: Bool,
        grooming: Bool,
        veterinarian: Bool
    ) {
        let preferences = NotificationPreferences(
            walk: walk,
            grooming: grooming,
            veterinarian: veterinarian
        )

        if preferences.hasEnabledNotifications {
            savedPreferences = preferences
        }

        apply(preferences)
    }

    private func apply(_ preferences: NotificationPreferences) {
        displayData.isNotificationsEnabled = preferences.hasEnabledNotifications
        displayData.isWalkEnabled = preferences.walk
        displayData.isGroomingEnabled = preferences.grooming
        displayData.isVeterinarianEnabled = preferences.veterinarian
        state = .content(displayData)
        persistSettings()
        reminderController.syncReminders(
            requestAuthorizationIfNeeded: displayData.isNotificationsEnabled
        )
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
            } receiveValue: { [weak self] _ in
                self?.reminderController.removeAllReminders()
            }
            .store(in: &bag)
    }
}
