//
//  TabBarController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit

final class TabBarController: UITabBarController {
    private var petsMainCoordinator: PetsMainCoordinator?
    private var publicPetsCoordinator: PublicPetsCoordinator?
    private let imageLoader: ImageLoader = ImageLoadService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let petsNavigationController = UINavigationController()
        let petsMainCoordinator = PetsMainCoordinator(
            navigationController: petsNavigationController,
            petRepository: PetService(
                imageService: ImageUploadService()
            ),
            tipRepository: TipService(),
            ownerId: "test_owner_id", imageLoader: imageLoader
        )
        self.petsMainCoordinator = petsMainCoordinator
        
        petsMainCoordinator.start()
        petsNavigationController.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        petsNavigationController.tabBarItem.title = nil

        let publicPetsNavigationController = UINavigationController()
        let publicPetsCoordinator = PublicPetsCoordinator(navigationController: publicPetsNavigationController, petRepository: PublicPetService(), imageLoader: imageLoader)
        self.publicPetsCoordinator = publicPetsCoordinator
        publicPetsCoordinator.start()
        publicPetsNavigationController.tabBarItem.image = UIImage(systemName: "globe.americas.fill")

        
        let gameViewController = UIViewController()
        let navGameViewController = setupTabBatItem(for: gameViewController, image: "gamecontroller.fill")
        
        let userProfileController = UIViewController()
        let navUserProfileViewController = setupTabBatItem(for: userProfileController, image: "person.fill")
        
        setViewControllers([petsNavigationController, publicPetsNavigationController, navGameViewController, navUserProfileViewController], animated: true)
    }
    
    private func setupTabBatItem(for viewController: UIViewController, image: String) -> UINavigationController {
        viewController.tabBarItem.image = UIImage(systemName: image)
        viewController.tabBarItem.title = nil
        
        return UINavigationController(rootViewController: viewController)
    }
}
