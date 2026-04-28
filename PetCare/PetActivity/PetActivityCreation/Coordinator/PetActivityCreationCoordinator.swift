//
//  PetActivityCreationCoordinator.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class PetActivityCreationCoordinator: Coordinator {
    var onFinish: (() -> Void)?

    private let navigationController: UINavigationController
    private let initialActivity: PetActivityType
    private let initialSelectedPet: Pet?
    private let ownerId: String
    private let petRepository: PetRepository
    private let cache: PetCacheRepository
    private let imageLoader: ImageLoader
    private let reminderController: PetActivityReminderControlling

    init(
        initialActivity: PetActivityType,
        initialSelectedPet: Pet?,
        ownerId: String,
        petRepository: PetRepository,
        reminderController: PetActivityReminderControlling,
        cache: PetCacheRepository,
        imageLoader: ImageLoader,
        navigationController: UINavigationController
    ) {
        self.initialActivity = initialActivity
        self.initialSelectedPet = initialSelectedPet
        self.ownerId = ownerId
        self.petRepository = petRepository
        self.reminderController = reminderController
        self.cache = cache
        self.imageLoader = imageLoader
        self.navigationController = navigationController
    }

    func start() {
        let viewController = PetActivityCreationViewController(
            imageLoader: imageLoader,
            petActivityCreationViewModel: PetActivityCreationViewModel(
                initialActivity: initialActivity,
                initialSelectedPet: initialSelectedPet,
                ownerId: ownerId,
                petRepository: petRepository,
                activityRepository: PetActivityService(cache: cache),
                reminderController: reminderController,
                moduleOutput: self
            )
        )

        navigationController.pushViewController(viewController, animated: true)
    }
}

extension PetActivityCreationCoordinator: PetActivityCreationModuleOutput {
    func moduleWantsToClose() {
        onFinish?()
        navigationController.popViewController(animated: true)
    }
}
