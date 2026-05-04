//
//  MiniGameCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Swinject
import UIKit

final class MiniGameCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let resolver: Resolver
    private let ownerId: String

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
        let bestScoreRepository: MiniGameBestScoreRepository = resolver.resolve()
        let imageLoader: ImageLoader = resolver.resolve()
        
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
