//
//  PublicPetsCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Swinject
import UIKit

final class PublicPetsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let resolver: Resolver
    private let userId: String

    private var childCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        resolver: Resolver,
        userId: String
    ) {
        self.navigationController = navigationController
        self.resolver = resolver
        self.userId = userId
    }

    func start() {
        let petRepository: PublicPetRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let viewModel = PublicPetsViewModel(
            userId: userId,
            petRepository: petRepository,
            moduleOutput: self
        )

        let viewController = PublicPetsViewController(
            publicPetsViewModel: viewModel,
            imageLoader: imageLoader
        )

        navigationController.pushViewController(viewController, animated: true)
    }

    private func showPetProfile(_ pet: Pet) {
        let petFactsRepository: PetFactsRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let publicPetProfileCoordinator = PublicPetProfileCoordinator(
            navigationController: navigationController,
            pet: pet,
            petFactsRepository: petFactsRepository,
            imageLoader: imageLoader
        )

        childCoordinators.append(publicPetProfileCoordinator)

        publicPetProfileCoordinator.onFinish = { [weak self, weak publicPetProfileCoordinator] in
            if let publicPetProfileCoordinator {
                self?.removeChildCoordinator(publicPetProfileCoordinator)
            }
        }

        publicPetProfileCoordinator.start()
    }

    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

extension PublicPetsCoordinator: PublicPetsModuleOutput {
    func moduleWantsToOpenPetProfile(_ pet: Pet) {
        showPetProfile(pet)
    }
}
