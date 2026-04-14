//
//  PetAnalyticsCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 14/4/26.
//

import UIKit

final class PetAnalyticsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let petId: String
    private let pet: Pet
    private let imageLoader: ImageLoader
    
    init(
        navigationController: UINavigationController,
        petId: String,
        pet: Pet,
        imageLoader: ImageLoader
    ) {
        self.navigationController = navigationController
        self.petId = petId
        self.pet = pet
        self.imageLoader = imageLoader
    }
    
    func start() {
        let analyticsViewController = PetAnalyticsViewController(
            petAnalyticsViewModel: PetAnalyticsViewModel(
                petInput: PetAnalyticsInput(
                    petId: petId,
                    pet: pet
                ),
                petAnalyticsRepository: PetAnalyticsService(),
                contentBuilder: PetAnalyticsBuilder(),
                moduleOutput: self
            ), imageLoader: imageLoader
        )
        
        navigationController.pushViewController(analyticsViewController, animated: true)
    }
    
    private func showHistoryView(_ petId: String) {
        let historyController = ActivitiesHistoryViewController(
            activitiesHistoryViewModel: ActivitiesHistoryViewModel(
                petId: petId,
                activitiesHistoryRepository: ActivitiesHistoryService(),
                contentBuilder: ActivitiesHistoryBuilder()
            )
        )
        
        navigationController.pushViewController(historyController, animated: true)
    }
}

extension PetAnalyticsCoordinator: PetAnalyticsModuleOutput {
    func moduleWantsToOpenHistory(_ petId: String) {
        showHistoryView(petId)
    }
}
