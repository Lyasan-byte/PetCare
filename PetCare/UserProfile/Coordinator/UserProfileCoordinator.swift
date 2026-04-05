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

    func start() -> UIViewController {
        let viewModel = UserProfileViewModel(
            petRepository: petRepository,
            userProfileRepository: userProfileRepository,
            moduleOutput: self
        )
        userProfileViewModel = viewModel

        return UserProfileViewController(
            viewModel: viewModel,
            imageLoader: imageLoader
        )
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
        showPlaceholderScreen(titleText: NSLocalizedString("user.profile.settings.title", comment: ""))
    }
}

extension UserProfileCoordinator: UserProfileEditModuleOutput {
    func userProfileEditModuleDidSave() {
        navigationController.popViewController(animated: true)
        userProfileViewModel?.trigger(.refresh)
    }
}
