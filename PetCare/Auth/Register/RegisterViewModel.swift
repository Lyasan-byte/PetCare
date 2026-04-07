//
//  RegisterViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation
import UIKit
import Combine

final class RegisterViewModel: RegisterViewModeling {

    private(set) var stateDidChange = ObservableObjectPublisher()
    @Published private(set) var state: RegisterState = .loading {
        didSet {
            stateDidChange.send()
        }
    }

    private let authService: AuthRepository
    private weak var moduleOutput: RegisterModuleOutput?
    private var email = ""
    private var password = ""
    private var confirmPassword = ""
    private var bag = Set<AnyCancellable>()

    init(
        authService: AuthRepository,
        moduleOutput: RegisterModuleOutput?
    ) {
        self.authService = authService
        self.moduleOutput = moduleOutput
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

        case .confirmPasswordChanged(let value):
            confirmPassword = value
            updateContent()

        case .registerTapped:
            register()

        case .googleTapped:
            signInWithGoogle()

        case .loginTapped:
            moduleOutput?.tapLogin()
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

        guard password.count >= 6 else {
            state = .error(NSLocalizedString("auth.validation.password_too_short", comment: ""))
            updateContent()
            return
        }

        guard password == confirmPassword else {
            state = .error(NSLocalizedString("auth.validation.passwords_do_not_match", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        authService.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                    self?.updateContent()
                }
            } receiveValue: { [weak self] in
                self?.moduleOutput?.moduleWantsToOpenRegistrationCompletion()
            }
            .store(in: &bag)
    }

    private func signInWithGoogle() {
        guard let vc = moduleOutput?.provideViewControllerForGoogleSignIn() else {
            state = .error(NSLocalizedString("error.common.try_again", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        authService.signInWithGoogle(presentingViewController: vc)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                    self?.updateContent()
                }
            } receiveValue: { [weak self] in
                self?.moduleOutput?.moduleWantsToOpenMainScreen()
            }
            .store(in: &bag)
    }
}
