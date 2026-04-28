//
//  AppCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 29.03.2026.
//

import Swinject
import UIKit
import FirebaseAuth

final class AppCoordinator {
    private var window: UIWindow?
    private var authCoordinator: AuthCoordinator?
    private var onboardingCoordinator: OnboardingCoordinator?
    private var stateDidChangeHandle: AuthStateDidChangeListenerHandle?
    
    private let resolver: Resolver
    private let onboardingStateRepository: OnboardingStateRepository
    
    init(
        resolver: Resolver,
        onboardingStateRepository: OnboardingStateRepository
    ) {
        self.resolver = resolver
        self.onboardingStateRepository = onboardingStateRepository
    }

    func start(_ scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        self.window = window

        self.stateDidChangeHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }

            if user == nil {
                if self.onboardingStateRepository.hasSeenOnboarding() {
                    self.showAuthFlow()
                } else {
                    self.showOnboardingFlow()
                }
            } else if let user, self.requiresRegistrationCompletion(for: user) {
                self.showAuthFlow(startingAt: .registrationCompletion)
            } else {
                self.showMainFlow()
            }
        }

        return window
    }

    func showAuthFlow(startingAt startDestination: AuthCoordinator.StartDestination = .login) {
        onboardingCoordinator = nil
        let navigationController = UINavigationController()
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            output: self
        )

        self.authCoordinator = authCoordinator
        authCoordinator.start(with: startDestination)

        window?.rootViewController = authCoordinator.navigationController
        window?.makeKeyAndVisible()
    }

    func showOnboardingFlow() {
        let navigationController = UINavigationController()
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController,
            onboardingStateRepository: onboardingStateRepository,
            marksAsSeenOnFinish: true,
            dismissOnFinish: false,
            moduleOutput: self
        )

        self.onboardingCoordinator = onboardingCoordinator
        onboardingCoordinator.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func showMainFlow() {
        authCoordinator = nil
        onboardingCoordinator = nil
        let nav = resolver.resolveOrFail(TabBarController.self)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    private func requiresRegistrationCompletion(for user: User) -> Bool {
        let displayName = user.displayName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return displayName.isEmpty
    }

    deinit {
        if let handle = stateDidChangeHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            stateDidChangeHandle = nil
        }
    }
}

extension AppCoordinator: AuthFlowOutput {
    func authFlowWantsToOpenMainScreen() {
        guard let user = Auth.auth().currentUser else {
            showAuthFlow()
            return
        }

        if requiresRegistrationCompletion(for: user) {
            showAuthFlow(startingAt: .registrationCompletion)
        } else {
            showMainFlow()
        }
    }
}

extension AppCoordinator: OnboardingModuleOutput {
    func onboardingModuleDidFinish() {
        onboardingCoordinator = nil
        showAuthFlow()
    }
}
