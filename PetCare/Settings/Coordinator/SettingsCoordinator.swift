//
//  SettingsCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import UIKit

final class SettingsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let settingsRepository: SettingsRepository
    private let settingsApplicationController: SettingsApplicationControlling
    private let accountRepository: SettingsAccountRepository
    private let reminderController: PetActivityReminderControlling

    var onFinish: (() -> Void)?

    init(
        navigationController: UINavigationController,
        settingsRepository: SettingsRepository,
        settingsApplicationController: SettingsApplicationControlling,
        accountRepository: SettingsAccountRepository,
        reminderController: PetActivityReminderControlling
    ) {
        self.navigationController = navigationController
        self.settingsRepository = settingsRepository
        self.settingsApplicationController = settingsApplicationController
        self.accountRepository = accountRepository
        self.reminderController = reminderController
    }

    func start() {
        let viewModel = SettingsViewModel(
            settingsRepository: settingsRepository,
            settingsApplicationController: settingsApplicationController,
            accountRepository: accountRepository,
            reminderController: reminderController,
            moduleOutput: self
        )
        let viewController = SettingsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SettingsCoordinator: SettingsModuleOutput {
    func settingsModuleDidClose() {
        onFinish?()
    }

    func provideViewControllerForAccountDeletion() -> UIViewController? {
        navigationController.topViewController
    }
}
