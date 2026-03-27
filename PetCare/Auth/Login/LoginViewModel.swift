//
//  LoginViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import UIKit
import Combine

final class LoginViewModel: ViewModel {

    typealias State = LoginState
    typealias Intent = LoginIntent

    @Published private(set) var state: LoginState = .loading

    private let authService: AuthServiceProtocol
    private let googleService: GoogleSignInService
    private let onOpenRegister: () -> Void
    private let onAuthorized: () -> Void

    private weak var presentingViewController: UIViewController?

    private var email = ""
    private var password = ""

    init(
        authService: AuthServiceProtocol,
        googleService: GoogleSignInService,
        onOpenRegister: @escaping () -> Void,
        onAuthorized: @escaping () -> Void
    ) {
        self.authService = authService
        self.googleService = googleService
        self.onOpenRegister = onOpenRegister
        self.onAuthorized = onAuthorized
    }

    func attach(viewController: UIViewController) {
        self.presentingViewController = viewController
    }

    func trigger(_ intent: LoginIntent) {
        switch intent {
        case .onDidLoad:
            updateContent()

        case .emailChanged(let value):
            email = value
            updateContent()

        case .passwordChanged(let value):
            password = value
            updateContent()

        case .loginTapped:
            login()

        case .googleTapped:
            signInWithGoogle()

        case .registerTapped:
            onOpenRegister()
        }
    }

    private func updateContent(isLoading: Bool = false) {
        state = .content(
            LoginContent(
                title: NSLocalizedString("auth.login.title", comment: ""),
                subtitle: NSLocalizedString("auth.login.subtitle", comment: ""),
                email: email,
                password: password,
                isLoginEnabled: isValidCredentials && !isLoading,
                isLoading: isLoading
            )
        )
    }

    private var isValidCredentials: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func login() {
        guard isValidCredentials else {
            state = .error(NSLocalizedString("auth.validation.fill_all_fields", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        authService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onAuthorized()
                case .failure(let error):
                    self?.state = .error(error.localizedDescription)
                    self?.updateContent()
                }
            }
        }
    }

    private func signInWithGoogle() {
        guard let vc = presentingViewController else {
            state = .error(NSLocalizedString("error.common.try_again", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        googleService.signIn(presentingViewController: vc) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onAuthorized()
                case .failure(let error):
                    self?.state = .error(error.localizedDescription)
                    self?.updateContent()
                }
            }
        }
    }
}
