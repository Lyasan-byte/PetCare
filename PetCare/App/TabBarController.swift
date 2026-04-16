//
//  TabBarController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit
import FirebaseAuth
import Combine

final class TabBarController: UITabBarController {
    private var petsMainCoordinator: PetsMainCoordinator?
    private var userProfileCoordinator: UserProfileCoordinator?
    private var publicPetsCoordinator: PublicPetsCoordinator?
    private let imageLoader: ImageLoader = ImageLoadService()
    private let settingsRepository: SettingsRepository = UserDefaultsSettingsService()
    private let settingsApplicationController: SettingsApplicationControlling = SettingsApplicationController()
    private var miniGameCoordinator: MiniGameCoordinator?
    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        bindLanguageChanges()
    }

    private func setupTabs() {
        setViewControllers(makeTabViewControllers(), animated: true)
    }

    private func bindLanguageChanges() {
        NotificationCenter.default.publisher(for: .settingsLanguageDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadInactiveTabsForCurrentLanguage()
            }
            .store(in: &bag)
    }

    private func reloadInactiveTabsForCurrentLanguage() {
        guard let currentViewControllers = viewControllers,
              currentViewControllers.indices.contains(selectedIndex) else {
            setupTabs()
            return
        }

        let selectedViewController = currentViewControllers[selectedIndex]
        let refreshedViewControllers = makeTabViewControllers(
            preservingViewController: selectedViewController,
            at: selectedIndex
        )
        setViewControllers(refreshedViewControllers, animated: false)
        selectedIndex = min(selectedIndex, refreshedViewControllers.count - 1)
    }

    private func makeTabViewControllers(
        preservingViewController preservedViewController: UIViewController? = nil,
        at preservedIndex: Int? = nil
    ) -> [UIViewController] {
        let ownerId = Auth.auth().currentUser?.uid ?? "test_owner_id"

        return [
            makePetsNavigationController(ownerId: ownerId, preservedViewController, preservedIndex == 0),
            makePublicPetsNavigationController(ownerId: ownerId, preservedViewController, preservedIndex == 1),
            makeMiniGameNavigationController(ownerId: ownerId, preservedViewController, preservedIndex == 2),
            makeUserProfileNavigationController(ownerId: ownerId, preservedViewController, preservedIndex == 3)
        ]
    }

    private func makePetsNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let imageUploader = ImageUploadService()
        let petRepository = PetService(
            imageService: imageUploader
        )
        let imageLoader = ImageLoadService()
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
            imageLoader: imageLoader
        )
        self.petsMainCoordinator = petsMainCoordinator

        petsMainCoordinator.start()
        petsNavigationController.tabBarItem.image = UIImage(systemName: "pawprint.fill")
        petsNavigationController.tabBarItem.title = nil
        return petsNavigationController
    }

    private func makePublicPetsNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

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
        return publicPetsNavigationController
    }

    private func makeMiniGameNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let imageUploader = ImageUploadService()
        let petRepository = PetService(
            imageService: imageUploader
        )
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
        return miniGameNavigationController
    }

    private func makeUserProfileNavigationController(
        ownerId: String,
        _ preservedViewController: UIViewController?,
        _ shouldPreserve: Bool
    ) -> UIViewController {
        if shouldPreserve, let preservedViewController {
            return preservedViewController
        }

        let imageUploader = ImageUploadService()
        let petRepository = PetService(
            imageService: imageUploader
        )
        let userProfileRepository = FirebaseUserProfileService(imageService: imageUploader)
        let reminderController = PetActivityReminderController(
            ownerId: ownerId,
            settingsRepository: settingsRepository,
            localNotificationsRepository: UserNotificationCenterService(),
            reminderStoreRepository: UserDefaultsPetActivityReminderStore()
        )
        let userProfileNavigationController = UINavigationController()
        let userProfileCoordinator = UserProfileCoordinator(
            navigationController: userProfileNavigationController,
            petRepository: petRepository,
            userProfileRepository: userProfileRepository,
            settingsRepository: settingsRepository,
            settingsApplicationController: settingsApplicationController,
            reminderController: reminderController,
            bestScoreRepository: UserDefaultsMiniGameBestScoreService(),
            imageLoader: imageLoader
        )
        self.userProfileCoordinator = userProfileCoordinator

        userProfileCoordinator.start()
        userProfileNavigationController.tabBarItem.image = UIImage(systemName: "person.fill")
        userProfileNavigationController.tabBarItem.title = nil
        return userProfileNavigationController
    }
}
