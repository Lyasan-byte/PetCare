//
//  PublicPetProfileCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import UIKit

final class PublicPetProfileCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let pet: Pet
    private let imageLoader: ImageLoader

    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController, pet: Pet, imageLoader: ImageLoader) {
        self.navigationController = navigationController
        self.pet = pet
        self.imageLoader = imageLoader
    }

    func start() {
        let viewController = PublicPetProfileViewController(
            publicPetProfileViewModel: PublicPetProfileViewModel(
                pet: pet,
                userRepository: FirestoreUserService(),
                moduleOutput: self
            ),
            imageLoader: imageLoader
        )

        navigationController.pushViewController(viewController, animated: true)
    }
}

extension PublicPetProfileCoordinator: PublicPetProfileModuleOutput {
    func moduleOutputWantsToClose() {
        onFinish?()
        navigationController.popViewController(animated: true)
    }
}
