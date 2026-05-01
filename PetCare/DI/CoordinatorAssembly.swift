//
//  CoordinatorAssembly.swift
//  PetCare
//
//  Created by Ляйсан on 28/4/26.
//

import Swinject
import UIKit

final class CoordinatorAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(AppCoordinator.self) { resolver in
            AppCoordinator(
                resolver: resolver,
                onboardingStateRepository: resolver
                    .resolveOrFail(OnboardingStateRepository.self)
            )
        }
        
        container.register(TabBarController.self) { resolver in
            TabBarController(resolver: resolver)
        }
        
        container.register(PetActivityReminderControlling.self) { (
            resolver: Resolver,
            ownerId: String) -> PetActivityReminderController in
            
            PetActivityReminderController(
                ownerId: ownerId,
                settingsRepository: resolver.resolveOrFail(SettingsRepository.self),
                localNotificationsRepository: resolver.resolveOrFail(LocalNotificationsRepository.self),
                reminderStoreRepository: resolver.resolveOrFail(PetActivityReminderStoreRepository.self)
            )
        }
        
        container.register(PetsMainCoordinator.self) { (
            resolver: Resolver,
            navigationController: UINavigationController,
            ownerId: String
        ) -> PetsMainCoordinator in
            
            let reminderController = resolver.resolveOrFail(
                PetActivityReminderControlling.self,
                argument: ownerId
            )

            reminderController.syncReminders(requestAuthorizationIfNeeded: false)

            return PetsMainCoordinator(
                navigationController: navigationController,
                petRepository: resolver.resolveOrFail(PetRepository.self),
                tipRepository: resolver.resolveOrFail(TipRepository.self),
                petFactsRepository: resolver.resolveOrFail(PetFactsRepository.self),
                ownerId: ownerId,
                reminderController: reminderController,
                cache: resolver.resolveOrFail(PetCacheRepository.self),
                imageLoader: resolver.resolveOrFail(ImageLoader.self)
            )
        }
        
        container.register(PublicPetsCoordinator.self) { (
            resolver,
            navigationController: UINavigationController,
            userId: String) -> PublicPetsCoordinator in
            
            PublicPetsCoordinator(
                navigationController: navigationController,
                userId: userId,
                petRepository: resolver.resolveOrFail(PublicPetRepository.self),
                petFactsRepository: resolver.resolveOrFail(PetFactsRepository.self),
                imageLoader: resolver.resolveOrFail(ImageLoader.self)
            )
        }
        
        container.register(MiniGameCoordinator.self) { (
            resolver: Resolver,
            navigationController: UINavigationController,
            ownerId: String
        ) -> MiniGameCoordinator in

            MiniGameCoordinator(
                navigationController: navigationController,
                petRepository: resolver.resolveOrFail(PetRepository.self),
                ownerId: ownerId,
                imageLoader: resolver.resolveOrFail(ImageLoader.self),
                bestScoreRepository: resolver.resolveOrFail(MiniGameBestScoreRepository.self)
            )
        }
        
        container.register(UserProfileCoordinator.self) { (
            resolver: Resolver,
            navigationController: UINavigationController,
            ownerId: String
        ) -> UserProfileCoordinator in
            
            let reminderController = resolver.resolveOrFail(
                PetActivityReminderControlling.self,
                argument: ownerId
            )

            return UserProfileCoordinator(
                navigationController: navigationController,
                petRepository: resolver.resolveOrFail(PetRepository.self),
                userProfileRepository: resolver.resolveOrFail(UserProfileRepository.self),
                settingsRepository: resolver.resolveOrFail(SettingsRepository.self),
                settingsApplicationController: resolver.resolveOrFail(SettingsApplicationControlling.self),
                reminderController: reminderController,
                bestScoreRepository: resolver.resolveOrFail(MiniGameBestScoreRepository.self),
                imageLoader: resolver.resolveOrFail(ImageLoader.self)
            )
        }
    }
}
