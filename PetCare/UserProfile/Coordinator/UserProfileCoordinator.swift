//
//  UserProfileCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Swinject
import UIKit

final class UserProfileCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let resolver: Resolver
    private let ownerId: String

    private var userProfileViewModel: UserProfileViewModel?
    private var childCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        resolver: Resolver,
        ownerId: String
    ) {
        self.navigationController = navigationController
        self.resolver = resolver
        self.ownerId = ownerId
    }

    private func showSettings() {
        let settingsRepository: SettingsRepository = resolver.resolve()
        let settingsApplicationController: SettingsApplicationControlling = resolver.resolve()
        let accountRepository: SettingsAccountRepository = resolver.resolve()
        let reminderController: PetActivityReminderControlling = resolver.resolve(argument: ownerId)
        
        let settingsCoordinator = SettingsCoordinator(
            navigationController: navigationController,
            settingsRepository: settingsRepository,
            settingsApplicationController: settingsApplicationController,
            accountRepository: accountRepository,
            reminderController: reminderController
        )
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.onFinish = { [weak self, weak settingsCoordinator] in
            guard let settingsCoordinator else { return }
            self?.removeChildCoordinator(settingsCoordinator)
        }
        settingsCoordinator.start()
    }

    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    func start() {
        let petRepository: PetRepository = resolver.resolve()
        let bestScoreRepository: MiniGameBestScoreRepository = resolver.resolve()
        let userProfileRepository: UserProfileRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let viewModel = UserProfileViewModel(
            petRepository: petRepository,
            bestScoreRepository: bestScoreRepository,
            userProfileRepository: userProfileRepository,
            moduleOutput: self
        )
        userProfileViewModel = viewModel

        let viewController = UserProfileViewController(
            viewModel: viewModel,
            imageLoader: imageLoader
        )
        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showPlaceholderScreen(titleText: String) {
        let viewController = PlaceholderViewController(
            titleText: titleText,
            message: NSLocalizedString("user.profile.settings.placeholder", comment: "")
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showEditProfile(for user: UserProfileUser) {
        let userProfileRepository: UserProfileRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let viewModel = UserProfileEditViewModel(
            user: user,
            userProfileRepository: userProfileRepository,
            moduleOutput: self
        )

        let viewController = UserProfileEditViewController(
            viewModel: viewModel,
            imageLoader: imageLoader
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension UserProfileCoordinator: UserProfileModuleOutput {
    func userProfileModuleDidRequestEdit(_ user: UserProfileUser) {
        showEditProfile(for: user)
    }

    func userProfileModuleDidRequestSettings() {
        showSettings()
    }
}

extension UserProfileCoordinator: UserProfileEditModuleOutput {
    func userProfileEditModuleDidSave() {
        navigationController.popViewController(animated: true)
        userProfileViewModel?.trigger(.refresh)
    }
}
