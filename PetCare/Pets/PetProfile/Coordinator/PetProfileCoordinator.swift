//
//  PetProfileCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 31/3/26.
//

import UIKit

enum PetProfileCoordinatorResult {
    case updated
    case deleted
    case closed
}

final class PetProfileCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let ownerId: String
    private let petRepository: PetRepository
    private var petProfileViewModel: PetProfileViewModel?
    private let pet: Pet
    private let imageLoader: ImageLoader
    
    private var childCoordinators: [Coordinator] = []
    
    var onFinish: ((PetProfileCoordinatorResult) -> Void)?
    
    init(
        navigationController: UINavigationController,
        ownerId: String,
        petRepository: PetRepository,
        pet: Pet,
        imageLoader: ImageLoader
    ) {
        self.navigationController = navigationController
        self.ownerId = ownerId
        self.petRepository = petRepository
        self.pet = pet
        self.imageLoader = imageLoader
    }
    
    func start() {
        let viewModel = PetProfileViewModel(pet: pet, moduleOutput: self)
        self.petProfileViewModel = viewModel
        let viewController = PetProfileViewController(petProfileViewModel: viewModel, imageLoader: imageLoader)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showEditPet(_ pet: Pet) {
        let petFormCoordinator = PetFormCoordinator(navigationController: navigationController, petRepository: petRepository, imageLoader: imageLoader)
        
        childCoordinators.append(petFormCoordinator)
        
        petFormCoordinator.onFinish = { [weak self, weak petFormCoordinator] route in
            switch route {
            case .closed:
                break
            case .saved(let pet):
                self?.petProfileViewModel?.update(pet)
                self?.onFinish?(.updated)
            case .deleted:
                self?.navigationController.popViewController(animated: true)
                self?.onFinish?(.deleted)
            }
            
            if let petFormCoordinator {
                self?.removeCoordinator(petFormCoordinator)
            }
        }
        petFormCoordinator.showEdit(pet: pet)
    }
    
    private func showAddActivity(_ pet: Pet) {
        let petActivityCoordinator = PetActivityCreationCoordinator(
            initialActivity: .walk,
            initialSelectedPet: pet,
            ownerId: ownerId,
            petRepository: petRepository,
            imageLoader: imageLoader,
            navigationController: navigationController
        )
        
        childCoordinators.append(petActivityCoordinator)
        
        petActivityCoordinator.onFinish = { [weak self, weak petActivityCoordinator] in
            if let petActivityCoordinator {
                self?.removeCoordinator(petActivityCoordinator)
            }
        }
        petActivityCoordinator.start()
    }
    
    private func removeCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator})
    }
}

extension PetProfileCoordinator: PetProfileModuleOutput {
    func petProfileModuleDidRequestAddActivity(_ pet: Pet) {
        showAddActivity(pet)
    }
    
    func petProfileModuleDidRequestEdit(_ pet: Pet) {
         showEditPet(pet)
    }
    
    func petProfileModuleDidRequestAnalytics(_ pet: Pet) {
         
    }
    
    func petProfileModuleDidClose() {
        onFinish?(.closed)
        navigationController.popViewController(animated: true)
    }
}
