//
//  PetFormCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit

enum PetFormScreenResult {
    case closed
    case saved(Pet)
    case deleted
}

final class PetFormCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petRepository: PetRepository
    private let mode: PetFormMode
    private let imageLoader: ImageLoader
    
    var onFinish: ((PetFormScreenResult) -> Void)?
    
    init(navigationController: UINavigationController, petRepository: PetRepository, imageLoader: ImageLoader, mode: PetFormMode) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.imageLoader = imageLoader
        self.mode = mode
    }
    
    func start() {
        let viewController = PetFormViewController(
            petFormViewModel: PetFormViewModel(
                petRepository: petRepository,
                mode: mode, moduleOutput: self,
            ), imageLoader: imageLoader
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}


extension PetFormCoordinator: PetFormModuleOutput {
    func petFormModuleDidSave(_ pet: Pet) {
        onFinish?(.saved(pet))
        navigationController.popViewController(animated: true)
    }
    
    func petFormModuleDidDelete() {
        onFinish?(.deleted)
        navigationController.popViewController(animated: true)
    }
    
    func petFormModuleDidClose() {
        onFinish?(.closed)
        navigationController.popViewController(animated: true)
    }
}
