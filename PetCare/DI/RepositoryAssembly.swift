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
        registerTipServices(in: container)
        registerPetFactsServices(in: container)
        registerPetServices(in: container)
        registerProfileServices(in: container)

        container.register(PublicPetRepository.self) { _ in
            PublicPetService()
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

private extension RepositoryAssembly {
    func registerTipServices(in container: Swinject.Container) {
        container.register(TipCacheRepository.self) { _ in
            SwiftDataTipCacheService(modelContext: Self.makeModelContext())
        }
        .inObjectScope(.container)

        container.register(TipService.self) { resolver in
            TipService(cache: resolver.resolve())
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
    }

    func registerPetFactsServices(in container: Swinject.Container) {
        container.register(PetFactsCacheRepository.self) { _ in
            SwiftDataPetFactsCacheService(modelContext: Self.makeModelContext())
        }
        .inObjectScope(.container)

        container.register(PetFactsService.self) { resolver in
            PetFactsService(cache: resolver.resolve())
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
    }

    func registerPetServices(in container: Swinject.Container) {
        container.register(PetCacheRepository.self) { _ in
            PetCacheService(modelContext: Self.makeModelContext())
        }
        .inObjectScope(.container)

        container.register(PetRepository.self) { resolver in
            PetService(
                cache: resolver.resolve(),
                imageService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

    func registerProfileServices(in container: Swinject.Container) {
        container.register(UserProfileRepository.self) { resolver in
            FirebaseUserProfileService(
                imageService: resolver.resolve()
            )
        }
        .inObjectScope(.container)
    }

    static func makeModelContext() -> ModelContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Failed to get AppDelegate")
        }

        return appDelegate.modelContainer.mainContext
    }
}
