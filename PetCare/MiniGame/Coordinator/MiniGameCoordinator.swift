//
//  MiniGameCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petRepository: PetRepository
    private let ownerId: String
    private let imageLoader: ImageLoader
    private let bestScoreRepository: MiniGameBestScoreRepository

    init(
        navigationController: UINavigationController,
        petRepository: PetRepository,
        ownerId: String,
        imageLoader: ImageLoader,
        bestScoreRepository: MiniGameBestScoreRepository
    ) {
        self.navigationController = navigationController
        self.petRepository = petRepository
        self.ownerId = ownerId
        self.imageLoader = imageLoader
        self.bestScoreRepository = bestScoreRepository
    }

    func start() {
        let miniGameViewModel = MiniGameViewModel(
            petRepository: petRepository,
            bestScoreRepository: bestScoreRepository,
            ownerId: ownerId,
            moduleOutput: self
        )
        let viewController = MiniGameViewController(
            miniGameViewModel: miniGameViewModel,
            imageLoader: imageLoader
        )

        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension MiniGameCoordinator: MiniGameModuleOutput {}
