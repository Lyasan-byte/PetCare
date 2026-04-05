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
            } else {
                self.showMainFlow()
            }
        }

        return window
    }

    func showAuthFlow() {
        let navigationController = UINavigationController()
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            output: self
        )

        self.authCoordinator = authCoordinator
        authCoordinator.start()

        window?.rootViewController = authCoordinator.navigationController
        window?.makeKeyAndVisible()
    }

    func showMainFlow() {
        authCoordinator = nil
        let nav = TabBarController()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
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
        showMainFlow()
    }
}
