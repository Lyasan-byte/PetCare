//
//  RepositoryAssembly.swift
//  PetCare
//
//  Created by Ляйсан on 28/4/26.
//

import Swinject
import SwiftData
import UIKit

final class RepositoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(TipCacheRepository.self) { _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Failed to get AppDelegate")
            }
            return SwiftDataTipCacheService(modelContext: appDelegate.modelContainer.mainContext)
        }
        .inObjectScope(.container)
        
        container.register(TipService.self) { resolver in
            TipService(cache: resolver.resolve())
        }
        .inObjectScope(.container)
        
        container.register(PetFactsCacheRepository.self) { _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Failed to get AppDelegate")
            }
            return SwiftDataPetFactsCacheService(
                modelContext: appDelegate.modelContainer.mainContext
            )
        }
        .inObjectScope(.container)
        
        container.register(PetFactsService.self) { resolver in
            PetFactsService(cache: resolver.resolve())
        }
        .inObjectScope(.container)
        
        container.register(TipRepository.self) { resolver in
            let tipRepository: TipService = resolver.resolve()
            return LocalizedTipService(
                tipRepository: tipRepository,
                translationRepository: resolver.resolve(),
                settingsRepository: resolver.resolve()
            )
        }
        .inObjectScope(.container)
        
        container.register(PetFactsRepository.self) { resolver in
            let petFactsRepository: PetFactsService = resolver.resolve()
            return LocalizedPetFactsService(
                petFactsRepository: petFactsRepository,
                translationRepository: resolver.resolve(),
                settingsRepository: resolver.resolve()
            )
        }
        .inObjectScope(.container)
        
        container.register(PetCacheRepository.self) { _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Failed to get AppDelegate")
            }
            return PetCacheService(modelContext: appDelegate.modelContainer.mainContext)
        }
        .inObjectScope(.container)
        
        container.register(PetRepository.self) { resolver in
            PetService(
                cache: resolver.resolve(),
                imageService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
        
        container.register(PublicPetRepository.self) { _ in
            PublicPetService()
        }
        .inObjectScope(.container)
        
        container.register(UserProfileRepository.self) { resolver in
            FirebaseUserProfileService(
                imageService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
        
        container.register(MiniGameBestScoreRepository.self) { _ in
            UserDefaultsMiniGameBestScoreService()
        }
        .inObjectScope(.container)
        
        container.register(SettingsAccountRepository.self) { _ in
            FirebaseSettingsAccountService()
        }
        .inObjectScope(.container)
    }
}
