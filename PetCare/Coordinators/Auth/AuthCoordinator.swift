//
//  AuthCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 29.03.2026.
//

import Foundation
import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {

    var navigationController: UINavigationController
    weak var output: AuthFlowOutput?
    private var isSwipeBackEnabled = true
    private let authRepository: AuthRepository

    init(
        navigationController: UINavigationController,
        output: AuthFlowOutput? = nil,
        authRepository: AuthRepository = FirebaseAuthService()
    ) {
        self.navigationController = navigationController
        self.output = output
        self.authRepository = authRepository
    }

    func start() {
        let loginViewController = makeLoginViewController()
        navigationController.setViewControllers([loginViewController], animated: false)
        navigationController.navigationBar.isHidden = true
    }

    private func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(
            authService: authRepository,
            moduleOutput: self
        )

        return LoginViewController(viewModel: viewModel)
    }

    private func makeRegisterViewController() -> UIViewController {
        let viewModel = RegisterViewModel(
            authService: authRepository,
            moduleOutput: self
        )

        return RegisterViewController(viewModel: viewModel)
    }

    private func showLogin() {
        let loginViewController = makeLoginViewController()
        navigationController.setViewControllers([loginViewController], animated: false)
    }

    private func showRegister() {
        let registerViewController = makeRegisterViewController()
        navigationController.setViewControllers([registerViewController], animated: false)
    }

    private func finishAuthFlow() {
        output?.authFlowWantsToOpenMainScreen()
    }
}

extension AuthCoordinator: AuthFlowInput {}

extension AuthCoordinator: LoginModuleOutput, RegisterModuleOutput {
    func moduleWantsToOpenMainScreen() {
        finishAuthFlow()
    }

    func provideViewControllerForGoogleSignIn() -> UIViewController? {
        navigationController.topViewController
    }

    func tapRegister() {
        showRegister()
    }
    
    func tapLogin() {
        showLogin()
    }
}
