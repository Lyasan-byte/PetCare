//
//  CoreAssembly.swift
//  PetCare
//
//  Created by Ляйсан on 28/4/26.
//

import Swinject
import Foundation

final class CoreAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(OnboardingStateRepository.self) { _ in
            UserDefaultsOnboardingStateService()
        }
        .inObjectScope(.container)
        
        container.register(SettingsRepository.self) { _ in
            UserDefaultsSettingsService()
        }
        .inObjectScope(.container)
        
        container.register(ImageLoader.self) { _ in
            ImageLoadService()
        }
        .inObjectScope(.container)
        
        container.register(ImageUploader.self) { _ in
            ImageUploadService()
        }
        .inObjectScope(.container)
        
        container.register(TranslationRepository.self) { _ in
            DeepLTranslationService()
        }
        .inObjectScope(.container)
        
        container.register(LocalNotificationsRepository.self) { _ in
            UserNotificationCenterService()
        }
        .inObjectScope(.container)
        
        container.register(PetActivityReminderStoreRepository.self) { _ in
            UserDefaultsPetActivityReminderStore()
        }
        .inObjectScope(.container)
        
        container.register(SettingsApplicationControlling.self) { _ in
            SettingsApplicationController()
        }
        .inObjectScope(.container)
    }
}
