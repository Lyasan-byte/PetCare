//
//  TabBarController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit
import FirebaseAuth
import SwiftData

final class TabBarController: UITabBarController {
    private var petsMainCoordinator: PetsMainCoordinator?
    private var userProfileCoordinator: UserProfileCoordinator?
    private var publicPetsCoordinator: PublicPetsCoordinator?
    private let imageLoader: ImageLoader = ImageLoadService()
    private let settingsRepository: SettingsRepository = UserDefaultsSettingsService()
    private let settingsApplicationController: SettingsApplicationControlling = SettingsApplicationController()
    private var miniGameCoordinator: MiniGameCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let ownerId = Auth.auth().currentUser?.uid ?? "test_owner_id"
        let imageUploader = ImageUploadService()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("Failed to get AppDelegate")
            return
        }

        let petCache = PetCacheService(modelContext: appDelegate.modelContainer.mainContext)

        let petRepository = PetService(
            cache: petCache,
            imageService: imageUploader
        )
        let imageLoader = ImageLoadService()
        let userProfileRepository = FirebaseUserProfileService(imageService: imageUploader)
        let reminderController = PetActivityReminderController(
            ownerId: ownerId,
            settingsRepository: settingsRepository,
            localNotificationsRepository: UserNotificationCenterService(),
            reminderStoreRepository: UserDefaultsPetActivityReminderStore()
        )

        reminderController.syncReminders(requestAuthorizationIfNeeded: false)

        let petsNavigationController = UINavigationController()
        let petsMainCoordinator = PetsMainCoordinator(
            navigationController: petsNavigationController,
            petRepository: petRepository,
            tipRepository: TipService(),
            ownerId: ownerId,
            reminderController: reminderController,
            cache: petCache,
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
            settingsRepository: settingsRepository,
            settingsApplicationController: settingsApplicationController,
            reminderController: reminderController,
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
