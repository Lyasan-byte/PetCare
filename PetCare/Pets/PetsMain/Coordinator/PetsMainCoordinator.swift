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
    
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, petRepository: PetRepository, tipRepository: TipRepository, ownerId: String) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.tipRepository = tipRepository
        self.ownerId = ownerId
    }
    
    func start() -> UIViewController {
        let petsMainViewModel = PetsMainViewModel(petRepository: petRepository, tipRepository: tipRepository, ownerId: ownerId)
        let petsMainViewController = PetsMainViewController(petsMainviewModel: petsMainViewModel)
        
        petsMainViewController.onRoute = { [weak self, weak petsMainViewModel] route in
            switch route {
            case .showAddPet:
                self?.showAddPetView(petsMainViewModel: petsMainViewModel)
            case .showQuickAction(_):
                 break
            case .showPet(_):
                 break
            case .showError(_):
                 break
            }
        }
        
        return petsMainViewController
    }
    
    private func showAddPetView(petsMainViewModel: PetsMainViewModel?) {
        let petFormCoordinator = PetFormCoordinator(navigationController: navigationController, petRepository: petRepository)
        
        childCoordinators.append(petFormCoordinator)
        
        petFormCoordinator.onFinish = { [weak self, weak petsMainViewModel, weak petFormCoordinator] result in
            switch result {
            case .saved(_):
                petsMainViewModel?.trigger(.refreshPets)
            case .closed:
                break
            case .deleted:
                break
            }
                        
            if let petFormCoordinator {
                self?.removeChildCoordinator(petFormCoordinator)
            }
        }
        
        petFormCoordinator.showCreate(ownerId: ownerId)
    }
    
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator} )
    }
}
