//
//  UserProfileCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit

final class UserProfileCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petRepository: PetRepository
    private let userProfileRepository: UserProfileRepository
    private let imageLoader: ImageLoader

    private var userProfileViewModel: UserProfileViewModel?
    private var childCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        petRepository: PetRepository,
        userProfileRepository: UserProfileRepository,
        imageLoader: ImageLoader
    ) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.userProfileRepository = userProfileRepository
        self.imageLoader = imageLoader
    }

    private func showSettings() {
        let settingsCoordinator = SettingsCoordinator(
            navigationController: navigationController,
            settingsRepository: UserDefaultsSettingsService(),
            settingsApplicationController: SettingsApplicationController(),
            accountRepository: FirebaseSettingsAccountService()
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
        let viewModel = UserProfileViewModel(
            petRepository: petRepository,
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
