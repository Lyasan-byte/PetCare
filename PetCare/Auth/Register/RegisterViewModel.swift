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

        case .emailChanged(let value):
            email = value
            updateContent()

        case .passwordChanged(let value):
            password = value
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
                isRegisterEnabled: isValidCredentials && !isLoading,
                isLoading: isLoading
            )
        )
    }

    private var isValidCredentials: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password.count >= 6
    }

    private func register() {
        guard !email.isEmpty, !password.isEmpty else {
            state = .error(NSLocalizedString("auth.validation.fill_all_fields", comment: ""))
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
