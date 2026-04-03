//
//  TabBarController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit

final class TabBarController: UITabBarController {
    private var petsMainCoordinator: PetsMainCoordinator?
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
        
        let petsViewController = petsMainCoordinator.start()
        
        petsNavigationController.setViewControllers([petsViewController], animated: false)
        petsNavigationController.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        petsNavigationController.tabBarItem.title = nil

        let publicPetsViewController = PublicPetsViewController(publicPetsViewModel: PublicPetsViewModel(moduleOutput: PublicPetsCoordinator()), imageLoader: imageLoader)
        let navPublicPetsViewController = setupTabBatItem(for: publicPetsViewController, image: "globe.americas.fill")
        
        let gameViewController = UIViewController()
        let navGameViewController = setupTabBatItem(for: gameViewController, image: "gamecontroller.fill")
        
        let userProfileController = UIViewController()
        let navUserProfileViewController = setupTabBatItem(for: userProfileController, image: "person.fill")
        
        setViewControllers([petsNavigationController, navPublicPetsViewController, navGameViewController, navUserProfileViewController], animated: true)
    }
    
    private func setupTabBatItem(for viewController: UIViewController, image: String) -> UINavigationController {
        viewController.tabBarItem.image = UIImage(systemName: image)
        viewController.tabBarItem.title = nil
        
        return UINavigationController(rootViewController: viewController)
    }
}
