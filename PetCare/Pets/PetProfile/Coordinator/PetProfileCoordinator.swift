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
    private let petRepository: PetRepository
    private let pet: Pet
    private var childCoordinators: [Coordinator] = []
    
    var onFinish: ((PetProfileCoordinatorResult) -> Void)?
    
    init(navigationController: UINavigationController, petRepository: PetRepository, pet: Pet) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.pet = pet
    }
    
    func start() {
        let viewModel = PetProfileViewModel(pet: pet)
        let viewController = PetProfileViewController(petProfileViewModel: viewModel)
        
        viewController.onRoute = { [weak self] route in
            switch route {
            case .showEdit(let pet):
                self?.showEditPet(pet)
            case .showAnalytics(_):
                 break
            case .close:
                self?.onFinish?(.closed)
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showEditPet(_ pet: Pet) {
        let petFormCoordinator = PetFormCoordinator(navigationController: navigationController, petRepository: petRepository)
        
        childCoordinators.append(petFormCoordinator)
        
        petFormCoordinator.onFinish = { [weak self, weak petFormCoordinator] result in
            switch result {
            case .saved(let pet):
                self?.onFinish?(.updated)
            case .closed:
                break
            case .deleted:
                break
            }
            
            if let petFormCoordinator {
                self?.removeCoordinator(petFormCoordinator)
            }
        }
        petFormCoordinator.showEdit(pet: pet)
    }
    
    private func removeCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator})
    }
}
