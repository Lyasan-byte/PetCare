//
//  AppCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 29.03.2026.
//

import Foundation
import UIKit
import FirebaseAuth

final class AppCoordinator {

    private var window: UIWindow?
    private var authCoordinator: AuthCoordinator?
    private var stateDidChangeHandle: AuthStateDidChangeListenerHandle?

    func start(_ scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        self.window = window

        self.stateDidChangeHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }

            if user == nil {
                self.showAuthFlow()
            } else if let user, self.requiresRegistrationCompletion(for: user) {
                self.showAuthFlow(startingAt: .registrationCompletion)
            } else {
                self.showMainFlow()
            }
        }

        return window
    }

    func showAuthFlow(startingAt startDestination: AuthCoordinator.StartDestination = .login) {
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

    func showMainFlow() {
        authCoordinator = nil
        let nav = TabBarController()
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
