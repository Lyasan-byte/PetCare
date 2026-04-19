//
//  AuthCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 29.03.2026.
//

import Foundation
import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {
    enum StartDestination {
        case login
        case registrationCompletion
    }

    var navigationController: UINavigationController
    weak var output: AuthFlowOutput?
    private var isSwipeBackEnabled = true
    private let authRepository: AuthRepository
    private let userProfileRepository: UserProfileRepository
    private let imageLoader: ImageLoader
    private let onboardingStateRepository: OnboardingStateRepository
    private var onboardingCoordinator: OnboardingCoordinator?

    init(
        navigationController: UINavigationController,
        output: AuthFlowOutput? = nil,
        authRepository: AuthRepository = FirebaseAuthService(),
        userProfileRepository: UserProfileRepository = FirebaseUserProfileService(
            imageService: ImageUploadService()
        ),
        imageLoader: ImageLoader = ImageLoadService(),
        onboardingStateRepository: OnboardingStateRepository = UserDefaultsOnboardingStateService()
    ) {
        self.navigationController = navigationController
        self.output = output
        self.authRepository = authRepository
        self.userProfileRepository = userProfileRepository
        self.imageLoader = imageLoader
        self.onboardingStateRepository = onboardingStateRepository
    }

    func start() {
        start(with: .login)
    }

    func start(with startDestination: StartDestination) {
        let initialViewController: UIViewController

        switch startDestination {
        case .login:
            initialViewController = makeLoginViewController()
        case .registrationCompletion:
            initialViewController = makeRegistrationCompletionViewController()
        }

        navigationController.setViewControllers([initialViewController], animated: false)
        navigationController.navigationBar.isHidden = true
    }

    private func makeRegistrationCompletionViewController() -> UIViewController {
        let viewModel = RegistrationCompletionViewModel(
            userProfileRepository: userProfileRepository,
            moduleOutput: self
        )

        return RegistrationCompletionViewController(
            viewModel: viewModel,
            imageLoader: imageLoader
        )
    }

    private func showRegistrationCompletion() {
        let viewController = makeRegistrationCompletionViewController()
        navigationController.setViewControllers([viewController], animated: true)
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

    private func showOnboardingHelp() {
        let onboardingNavigationController = UINavigationController()
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: onboardingNavigationController,
            onboardingStateRepository: onboardingStateRepository,
            marksAsSeenOnFinish: false,
            dismissOnFinish: true,
            moduleOutput: self
        )

        self.onboardingCoordinator = onboardingCoordinator
        onboardingCoordinator.start()
        navigationController.present(onboardingNavigationController, animated: true)
    }
}

extension AuthCoordinator: AuthFlowInput {}

extension AuthCoordinator: LoginModuleOutput, RegisterModuleOutput {
    func moduleWantsToOpenMainScreen() {
        finishAuthFlow()
    }

    func moduleWantsToOpenRegistrationCompletion() {
        showRegistrationCompletion()
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

    func moduleWantsToOpenOnboardingHelp() {
        showOnboardingHelp()
    }
}

extension AuthCoordinator: RegistrationCompletionModuleOutput {
    func registrationCompletionModuleDidFinish() {
        finishAuthFlow()
    }
}

extension AuthCoordinator: OnboardingModuleOutput {
    func onboardingModuleDidFinish() {
        onboardingCoordinator = nil
    }
}
