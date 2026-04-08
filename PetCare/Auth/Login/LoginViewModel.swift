//
//  LoginViewModel.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import UIKit
import Combine

final class LoginViewModel: LoginViewModeling {
    private(set) var stateDidChange = ObservableObjectPublisher()
    @Published private(set) var state: LoginState = .loading {
        didSet {
            stateDidChange.send()
        }
    }

    private let authService: AuthRepository
    private weak var moduleOutput: LoginModuleOutput?

    private var email = ""
    private var password = ""
    private var bag = Set<AnyCancellable>()

    init(
        authService: AuthRepository,
        moduleOutput: LoginModuleOutput?
    ) {
        self.authService = authService
        self.moduleOutput = moduleOutput
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
            moduleOutput?.tapRegister()
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

        authService.signIn(email: email, password: password)
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

    private func signInWithGoogle() {
        guard let presentingViewController = moduleOutput?.provideViewControllerForGoogleSignIn() else {
            state = .error(NSLocalizedString("error.common.try_again", comment: ""))
            updateContent()
            return
        }

        updateContent(isLoading: true)

        authService.signInWithGoogle(
            presentingViewController: presentingViewController
        )
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
