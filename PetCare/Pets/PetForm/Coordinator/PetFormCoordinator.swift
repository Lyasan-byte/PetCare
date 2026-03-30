//
//  PetFormCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit

final class PetFormCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petRepository: PetRepository
    
    var onFinish: ((PetFormScreenResult) -> Void)?
    
    init(navigationController: UINavigationController, petRepository: PetRepository) {
        self.navigationController = navigationController
        self.petRepository = petRepository
    }
    
    func showCreate(ownerId: String) {
        start(mode: .create(ownerId: ownerId))
    }
    
    func showEdit(pet: Pet) {
        start(mode: .edit(pet))
    }
    
    func start(mode: PetFormMode) {
        let viewController = PetFormViewController(petFormViewModel: PetFormViewModel(petRepository: petRepository, mode: mode))
        
        viewController.onFinish = { [weak self] result in
            self?.onFinish?(result)
            
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
