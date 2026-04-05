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
        
        let petsViewController = petsMainCoordinator.start()
        
        petsNavigationController.setViewControllers([petsViewController], animated: false)
        petsNavigationController.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        petsNavigationController.tabBarItem.title = nil

        let publicPetsViewController = UIViewController()
        let navPublicPetsViewController = setupTabBatItem(for: publicPetsViewController, image: "globe.americas.fill")
        
        let gameViewController = UIViewController()
        let navGameViewController = setupTabBatItem(for: gameViewController, image: "gamecontroller.fill")
        
        let userProfileNavigationController = UINavigationController()
        let userProfileCoordinator = UserProfileCoordinator(
            navigationController: userProfileNavigationController,
            petRepository: petRepository,
            userProfileRepository: userProfileRepository,
            imageLoader: imageLoader
        )
        self.userProfileCoordinator = userProfileCoordinator

        let userProfileController = userProfileCoordinator.start()
        userProfileNavigationController.setViewControllers([userProfileController], animated: false)
        userProfileNavigationController.tabBarItem.image = UIImage(systemName: "person.fill")
        userProfileNavigationController.tabBarItem.title = nil
        
        setViewControllers([petsNavigationController, navPublicPetsViewController, navGameViewController, userProfileNavigationController], animated: true)
    }
    
    private func setupTabBatItem(for viewController: UIViewController, image: String) -> UINavigationController {
        viewController.tabBarItem.image = UIImage(systemName: image)
        viewController.tabBarItem.title = nil
        
        return UINavigationController(rootViewController: viewController)
    }
}
