//
//  RegisterViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation
import UIKit
import Combine

final class RegisterViewModel: ViewModel {

    typealias State = RegisterState
    typealias Intent = RegisterIntent

    @Published private(set) var state: RegisterState = .loading

    private let authService: AuthServiceProtocol
    private let googleService: GoogleSignInService
    private let onOpenLogin: () -> Void
    private let onAuthorized: () -> Void

    private weak var presentingViewController: UIViewController?

    private var email = ""
    private var password = ""
    private var confirmPassword = ""

    init(
        authService: AuthServiceProtocol,
        googleService: GoogleSignInService,
        onOpenLogin: @escaping () -> Void,
        onAuthorized: @escaping () -> Void
    ) {
        self.authService = authService
        self.googleService = googleService
        self.onOpenLogin = onOpenLogin
        self.onAuthorized = onAuthorized
    }

    func attach(viewController: UIViewController) {
        self.presentingViewController = viewController
    }

    func trigger(_ intent: RegisterIntent) {
        switch intent {
        case .onDidLoad:
            updateContent()

        case .emailChanged(let email):
            self.email = email
            updateContent()

        case .passwordChanged(let password):
            self.password = password
            updateContent()

        case .confirmPasswordChanged(let confirmPassword):
            self.confirmPassword = confirmPassword
            updateContent()

        case .registerTapped:
            register()

        case .googleTapped:
            signInWithGoogle()

        case .loginTapped:
            onOpenLogin()
        }
    }

    private func updateContent(isLoading: Bool = false) {
        state = .content(
            RegisterContent(
                title: NSLocalizedString("auth.register.title", comment: ""),
                subtitle: NSLocalizedString("auth.register.subtitle", comment: ""),
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                isRegisterEnabled: isValidCredentials && !isLoading,
                isLoading: isLoading
            )
        )
    }

    private var isValidCredentials: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }

    private func register() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            state = .error(NSLocalizedString("auth.validation.fill_all_fields", comment: ""))
            updateContent()
            return
        }

        guard password == confirmPassword else {
            state = .error(NSLocalizedString("auth.validation.passwords_not_match", comment: ""))
            updateContent()
            return
        }

        guard password.count >= 6 else {
            state = .error(NSLocalizedString("auth.validation.password_too_short", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        authService.register(email: email, password: password) { [weak self] result in
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
        guard let presentingViewController else {
            state = .error(NSLocalizedString("error.common.try_again", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        googleService.signIn(presentingViewController: presentingViewController) { [weak self] result in
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

