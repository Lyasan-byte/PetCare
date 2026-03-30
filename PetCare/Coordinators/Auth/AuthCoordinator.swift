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

    init(
        navigationController: UINavigationController,
        output: AuthFlowOutput? = nil
    ) {
        self.navigationController = navigationController
        self.output = output
    }

    func start() {
        let loginViewController = makeLoginViewController()
        navigationController.setViewControllers([loginViewController], animated: false)
        navigationController.navigationBar.isHidden = true
    }

    private func makeLoginViewController() -> UIViewController {
        let viewModel = LoginViewModel(
            authService: FirebaseAuthService(),
            googleService: GoogleSignInService(),
            onOpenRegister: { [weak self] in
                self?.showRegister()
            },
            onAuthorized: { [weak self] in
                self?.finishAuthFlow()
            }
        )

        return LoginViewController(viewModel: viewModel)
    }

    private func makeRegisterViewController() -> UIViewController {
        let viewModel = RegisterViewModel(
            authService: FirebaseAuthService(),
            googleService: GoogleSignInService(),
            onOpenLogin: { [weak self] in
                guard let self = self else { return }
                let loginVC = self.makeLoginViewController()
                self.navigationController.setViewControllers([loginVC], animated: false)
            },
            onAuthorized: { [weak self] in
                self?.finishAuthFlow()
            }
        )

        return RegisterViewController(viewModel: viewModel)
    }

    private func showRegister() {
        let registerViewController = makeRegisterViewController()
        navigationController.setViewControllers([registerViewController], animated: false)
    }

    private func finishAuthFlow() {
        (output as? AppCoordinator)?.showMainFlow()
    }
}

extension AuthCoordinator: AuthFlowInput {}

