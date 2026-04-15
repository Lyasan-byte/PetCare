//
//  TabBarController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit
import FirebaseAuth

final class TabBarController: UITabBarController {
    private var petsMainCoordinator: PetsMainCoordinator?
    private var userProfileCoordinator: UserProfileCoordinator?
    private var publicPetsCoordinator: PublicPetsCoordinator?
    private var miniGameCoordinator: MiniGameCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let ownerId = Auth.auth().currentUser?.uid ?? "test_owner_id"
        let imageUploader = ImageUploadService()
        let petRepository = PetService(
            imageService: imageUploader
        )
        let imageLoader = ImageLoadService()
        let userProfileRepository = FirebaseUserProfileService(imageService: imageUploader)

        let petsNavigationController = UINavigationController()
        let petsMainCoordinator = PetsMainCoordinator(
            navigationController: petsNavigationController,
            petRepository: petRepository,
            tipRepository: TipService(),
            ownerId: ownerId,
            imageLoader: imageLoader
        )
        self.petsMainCoordinator = petsMainCoordinator

        petsMainCoordinator.start()
        petsNavigationController.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        petsNavigationController.tabBarItem.title = nil

        let publicPetsNavigationController = UINavigationController()
        let publicPetsCoordinator = PublicPetsCoordinator(
            navigationController: publicPetsNavigationController,
            userId: ownerId,
            petRepository: PublicPetService(),
            imageLoader: imageLoader
        )
        self.publicPetsCoordinator = publicPetsCoordinator

        publicPetsCoordinator.start()
        publicPetsNavigationController.tabBarItem.image = UIImage(systemName: "globe.americas.fill")

        let miniGameNavigationController = UINavigationController()
        let miniGameCoordinator = MiniGameCoordinator(
            navigationController: miniGameNavigationController,
            petRepository: petRepository,
            ownerId: ownerId,
            imageLoader: imageLoader,
            bestScoreRepository: UserDefaultsMiniGameBestScoreService()
        )
        self.miniGameCoordinator = miniGameCoordinator

        miniGameCoordinator.start()
        miniGameNavigationController.tabBarItem.image = UIImage(systemName: "gamecontroller.fill")
        miniGameNavigationController.tabBarItem.title = nil

        let userProfileNavigationController = UINavigationController()
        let userProfileCoordinator = UserProfileCoordinator(
            navigationController: userProfileNavigationController,
            petRepository: petRepository,
            userProfileRepository: userProfileRepository,
            imageLoader: imageLoader
        )
        self.userProfileCoordinator = userProfileCoordinator

        userProfileCoordinator.start()
        userProfileNavigationController.tabBarItem.image = UIImage(systemName: "person.fill")
        userProfileNavigationController.tabBarItem.title = nil

        setViewControllers(
            [
                petsNavigationController,
                publicPetsNavigationController,
                miniGameNavigationController,
                userProfileNavigationController
            ],
            animated: true
        )
    }
}
