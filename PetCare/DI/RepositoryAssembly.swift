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
        container.register(TipService.self) { _ in
            TipService()
        }
        
        container.register(PetFactsService.self) { _ in
            PetFactsService()
        }
        
        container.register(TipRepository.self) { resolver in
            LocalizedTipService(
                tipRepository: resolver.resolveOrFail(TipService.self),
                translationRepository: resolver.resolveOrFail(TranslationRepository.self),
                settingsRepository: resolver.resolveOrFail(SettingsRepository.self)
            )
        }
        
        container.register(PetFactsRepository.self) { resolver in
            LocalizedPetFactsService(
                petFactsRepository: resolver.resolveOrFail(PetFactsService.self),
                translationRepository: resolver.resolveOrFail(TranslationRepository.self),
                settingsRepository: resolver.resolveOrFail(SettingsRepository.self)
            )
        }
        
        container.register(PetCacheRepository.self) { _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Failed to get AppDelegate")
            }
            return PetCacheService(modelContext: appDelegate.modelContainer.mainContext)
        }
        
        container.register(PetRepository.self) { resolver in
            PetService(
                cache: resolver.resolveOrFail(PetCacheRepository.self),
                imageService: resolver.resolveOrFail(ImageUploader.self)
            )
        }
        
        container.register(PublicPetRepository.self) { _ in
            PublicPetService()
        }
        
        container.register(UserProfileRepository.self) { resolver in
            FirebaseUserProfileService(
                imageService: resolver.resolveOrFail(ImageUploader.self)
            )
        }
        
        container.register(MiniGameBestScoreRepository.self) { _ in
            UserDefaultsMiniGameBestScoreService()
        }
    }
}
