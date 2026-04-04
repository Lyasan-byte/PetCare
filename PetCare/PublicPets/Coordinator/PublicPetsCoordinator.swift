//
//  PublicPetsCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class PublicPetsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petRepository: PublicPetRepository
    private let imageLoader: ImageLoader
    
    init(navigationController: UINavigationController, petRepository: PublicPetRepository, imageLoader: ImageLoader) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.imageLoader = imageLoader
    }
    
    func start() {
        let viewController = PublicPetsViewController(
            publicPetsViewModel: PublicPetsViewModel(
                petRepository: petRepository,
                moduleOutput: self
            ), imageLoader: imageLoader
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPetProfile(_ pet: Pet) {
        
    }
}

extension PublicPetsCoordinator: PublicPetsModuleOutput {
    func moduleWantsToOpenPetProfile(_ pet: Pet) {
        showPetProfile(pet)
    }
}
