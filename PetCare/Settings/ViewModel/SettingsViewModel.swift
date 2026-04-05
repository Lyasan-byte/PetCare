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
    @Published private(set) var state = SettingsState.defaultValue {
        didSet {
            stateDidChange.send()
        }
    }

    private let settingsRepository: SettingsRepository
    private let settingsApplicationController: SettingsApplicationControlling
    private let accountRepository: SettingsAccountRepository
    private weak var moduleOutput: SettingsModuleOutput?
    private var bag = Set<AnyCancellable>()
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
        let storedState = settingsRepository.loadSettings()
        state = storedState

        if storedState.isNotificationsEnabled {
            savedPreferences = NotificationPreferences(
                grooming: storedState.isGroomingEnabled,
                veterinarian: storedState.isVeterinarianEnabled,
                generalReminders: storedState.isGeneralRemindersEnabled
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
        case .themeSelected(let theme):
            updateTheme(theme)
        case .languageSelected(let language):
            updateLanguage(language)
        case .deleteAccountTapped:
            state.isDeleteConfirmationPresented = true
        case .confirmDeleteAccount:
            state.isDeleteConfirmationPresented = false
            deleteAccount()
        case .dismissAlert:
            state.errorMessage = nil
            state.isDeleteConfirmationPresented = false
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
            isGeneralRemindersEnabled: preferences.generalReminders,
            theme: state.theme,
            language: state.language,
            isDeletingAccount: state.isDeletingAccount,
            errorMessage: state.errorMessage,
            isDeleteConfirmationPresented: state.isDeleteConfirmationPresented
        )
        persistSettings()
    }

    private func updateTheme(_ theme: SettingsTheme) {
        guard state.theme != theme else { return }
        state.theme = theme
        persistSettings()
        settingsApplicationController.applyTheme(theme)
    }

    private func updateLanguage(_ language: SettingsLanguage) {
        guard state.language != language else { return }
        state.language = language
        persistSettings()
        settingsApplicationController.applyLanguage(language)
    }

    private func persistSettings() {
        settingsRepository.save(settings: state)
    }

    private func deleteAccount() {
        guard !state.isDeletingAccount else { return }

        state.isDeletingAccount = true
        state.errorMessage = nil

        accountRepository.deleteCurrentAccount()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.state.isDeletingAccount = false

                if case .failure(let error) = completion {
                    self.state.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
            }
            .store(in: &bag)
    }
}
