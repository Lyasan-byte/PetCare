//
//  OnboardingCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let onboardingStateRepository: OnboardingStateRepository
    private let marksAsSeenOnFinish: Bool
    private let dismissOnFinish: Bool

    weak var moduleOutput: OnboardingModuleOutput?

    init(
        navigationController: UINavigationController,
        onboardingStateRepository: OnboardingStateRepository,
        marksAsSeenOnFinish: Bool,
        dismissOnFinish: Bool,
        moduleOutput: OnboardingModuleOutput? = nil
    ) {
        self.navigationController = navigationController
        self.onboardingStateRepository = onboardingStateRepository
        self.marksAsSeenOnFinish = marksAsSeenOnFinish
        self.dismissOnFinish = dismissOnFinish
        self.moduleOutput = moduleOutput
    }

    func start() {
        let viewController = OnboardingFlowViewController()
        viewController.onFinish = { [weak self] in
            self?.finish()
        }

        navigationController.setViewControllers([viewController], animated: false)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
    }

    private func finish() {
        if marksAsSeenOnFinish {
            onboardingStateRepository.setHasSeenOnboarding(true)
        }

        if dismissOnFinish {
            navigationController.dismiss(animated: true) { [weak self] in
                self?.moduleOutput?.onboardingModuleDidFinish()
            }
            return
        }

        moduleOutput?.onboardingModuleDidFinish()
    }
}
