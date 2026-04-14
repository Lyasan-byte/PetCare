//
//  PetsMainCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 29/3/26.
//

import UIKit

final class PetsMainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petRepository: PetRepository
    private let tipRepository: TipRepository
    private let ownerId: String
    private let imageLoader: ImageLoader

    private var petsMainViewModel: PetsMainViewModel?

    private var childCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        petRepository: PetRepository,
        tipRepository: TipRepository,
        ownerId: String,
        imageLoader: ImageLoader
    ) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.tipRepository = tipRepository
        self.ownerId = ownerId
        self.imageLoader = imageLoader
    }

    func start() {
        let petsMainViewModel = PetsMainViewModel(
            petRepository: petRepository,
            tipRepository: tipRepository,
            moduleOutput: self,
            ownerId: ownerId
        )
        self.petsMainViewModel = petsMainViewModel
        let viewController = PetsMainViewController(
            petsMainviewModel: petsMainViewModel,
            imageLoader: ImageLoadService()
        )

        navigationController.setViewControllers([viewController], animated: true)
    }

    private func showAddPetView() {
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
        let petProfileCoordinator = PetProfileCoordinator(
            navigationController: navigationController,
            ownerId: ownerId,
            petRepository: petRepository,
            pet: pet,
            imageLoader: imageLoader
        )

        childCoordinators.append(petProfileCoordinator)
        petProfileCoordinator.onFinish = { [weak self, weak petsMainViewModel, weak petProfileCoordinator] result in
            switch result {
            case .updated:
                petsMainViewModel?.trigger(.refreshPets)
            case .deleted:
                petsMainViewModel?.trigger(.refreshPets)
            case .closed:
                break
            case .createdActivity:
                petsMainViewModel?.trigger(.refreshPets)
            }
            if let petProfileCoordinator {
                self?.removeChildCoordinator(petProfileCoordinator)
            }
        }
        petProfileCoordinator.start()
    }

    private func showAddActivity(_ activity: PetActivityType) {
        let petActivityCreationCoordinator = PetActivityCreationCoordinator(
            initialActivity: activity,
            initialSelectedPet: nil,
            ownerId: ownerId,
            petRepository: petRepository,
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
