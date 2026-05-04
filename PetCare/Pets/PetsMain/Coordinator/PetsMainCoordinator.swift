//
//  PetsMainCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 29/3/26.
//

import Swinject
import UIKit

final class PetsMainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let resolver: Resolver
    private let ownerId: String
    
    private var petsMainViewModel: PetsMainViewModel?
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

    func start() {
        let petRepository: PetRepository = resolver.resolve()
        let tipRepository: TipRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let petsMainViewModel = PetsMainViewModel(
            petRepository: petRepository,
            tipRepository: tipRepository,
            moduleOutput: self,
            ownerId: ownerId
        )
        self.petsMainViewModel = petsMainViewModel
        let viewController = PetsMainViewController(
            petsMainviewModel: petsMainViewModel,
            imageLoader: imageLoader
        )

        navigationController.setViewControllers([viewController], animated: true)
    }

    private func showAddPetView() {
        let petRepository: PetRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let petFormCoordinator = PetFormCoordinator(
            navigationController: navigationController,
            petRepository: petRepository,
            imageLoader: imageLoader,
            mode: .create(ownerId: ownerId)
        )

        childCoordinators.append(petFormCoordinator)

        petFormCoordinator.onFinish = { [weak self, weak petsMainViewModel, weak petFormCoordinator] result in
            switch result {
            case .saved:
                petsMainViewModel?.trigger(.refreshPets)
            case .deleted:
                petsMainViewModel?.trigger(.refreshPets)
            case .closed: break
            }
            if let petFormCoordinator {
                self?.removeChildCoordinator(petFormCoordinator)
            }
        }
        petFormCoordinator.start()
    }

    private func showPet(_ pet: Pet) {
        let petRepository: PetRepository = resolver.resolve()
        let reminderController: PetActivityReminderControlling = resolver.resolve(argument: ownerId)
        let petFactsRepository: PetFactsRepository = resolver.resolve()
        let cache: PetCacheRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let petProfileCoordinator = PetProfileCoordinator(
            navigationController: navigationController,
            ownerId: ownerId,
            petRepository: petRepository,
            petFactsRepository: petFactsRepository,
            pet: pet,
            reminderController: reminderController,
            cache: cache,
            imageLoader: imageLoader
        )

        childCoordinators.append(petProfileCoordinator)
        
        petProfileCoordinator.onChange = { [weak self] in
            self?.petsMainViewModel?.trigger(.refreshPets)
        }
        
        petProfileCoordinator.onFinish = { [weak self, weak petsMainViewModel, weak petProfileCoordinator] result in
            switch result {
            case .deleted:
                petsMainViewModel?.trigger(.refreshPets)
            case .closed:
                break
            }
            if let petProfileCoordinator {
                self?.removeChildCoordinator(petProfileCoordinator)
            }
        }
        petProfileCoordinator.start()
    }

    private func showAddActivity(_ activity: PetActivityType) {
        let petRepository: PetRepository = resolver.resolve()
        let reminderController: PetActivityReminderControlling = resolver.resolve(argument: ownerId)
        let cache: PetCacheRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
        let petActivityCreationCoordinator = PetActivityCreationCoordinator(
            initialActivity: activity,
            initialSelectedPet: nil,
            ownerId: ownerId,
            petRepository: petRepository,
            reminderController: reminderController,
            cache: cache,
            imageLoader: imageLoader,
            navigationController: navigationController
        )

        childCoordinators.append(petActivityCreationCoordinator)

        petActivityCreationCoordinator.onFinish = { [weak self, weak petActivityCreationCoordinator] in
            self?.petsMainViewModel?.trigger(.refreshPets)
            if let petActivityCreationCoordinator {
                self?.removeChildCoordinator(petActivityCreationCoordinator)
            }
        }

        petActivityCreationCoordinator.start()
    }

    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

extension PetsMainCoordinator: PetsMainModuleOutput {
    func petsMainModuleDidRequestAddPet() {
        showAddPetView()
    }

    func petsMainModuleDidRequestOpenPet(_ pet: Pet) {
        showPet(pet)
    }

    func petsMainModuleDidRequestAddActivity(_ activity: PetActivityType) {
        showAddActivity(activity)
    }
}
