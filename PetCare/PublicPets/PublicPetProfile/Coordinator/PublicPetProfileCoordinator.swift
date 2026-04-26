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
    private let petFactsRepository: PetFactsRepository
    private let imageLoader: ImageLoader

    var onFinish: (() -> Void)?

    init(
        navigationController: UINavigationController,
        pet: Pet,
        petFactsRepository: PetFactsRepository,
        imageLoader: ImageLoader
    ) {
        self.navigationController = navigationController
        self.pet = pet
        self.petFactsRepository = petFactsRepository
        self.imageLoader = imageLoader
    }

    func start() {
        let viewController = PublicPetProfileViewController(
            publicPetProfileViewModel: PublicPetProfileViewModel(
                pet: pet,
                userRepository: FirestoreUserService(),
                petFactsRepository: petFactsRepository,
                moduleOutput: self
            ),
            imageLoader: imageLoader
        )

        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPetFactsSheet(petFact: PetFact?) {
        let viewController = PetFactsViewController(petFact: petFact)
        let petFactsNavigationController = UINavigationController(rootViewController: viewController)
        
        viewController.onClose = { [weak petFactsNavigationController] in
            petFactsNavigationController?.dismiss(animated: true)
        }
        
        petFactsNavigationController.modalPresentationStyle = .pageSheet
        
        self.navigationController.present(petFactsNavigationController, animated: true)
    }
}

extension PublicPetProfileCoordinator: PublicPetProfileModuleOutput {
    func moduleWantsToOpenFactsSheet(petFact: PetFact?) {
        showPetFactsSheet(petFact: petFact)
    }
    
    func moduleOutputWantsToClose() {
        onFinish?()
        navigationController.popViewController(animated: true)
    }
}
