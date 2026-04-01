//
//  LoginViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 27.03.2026.
//

import Foundation
import UIKit
import Combine

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel
    private let contentView = LoginView()
    private var bag = Set<AnyCancellable>()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupActions()
        viewModel.attach(viewController: self)
        viewModel.trigger(.onDidLoad)
    }

    private func bind() {
        viewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.render()
            }
            .store(in: &bag)
    }

    private func setupActions() {
        contentView.emailFieldView.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        contentView.passwordFieldView.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        contentView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        contentView.googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        contentView.switchButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            contentView.setLoading(true)

        case .content(let content):
            contentView.configure(title: content.title, subtitle: content.subtitle)
            contentView.emailFieldView.textField.text = content.email
            contentView.passwordFieldView.textField.text = content.password
            contentView.setLoginButtonEnabled(content.isLoginEnabled)
            contentView.setLoading(content.isLoading)

        case .error(let message):
            contentView.setLoading(false)
            showAlert(message: message)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("common.error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.ok", comment: ""), style: .default))
        present(alert, animated: true)
    }

    @objc private func emailChanged() {
        viewModel.trigger(.emailChanged(contentView.emailFieldView.textField.text ?? ""))
    }

    @objc private func passwordChanged() {
        viewModel.trigger(.passwordChanged(contentView.passwordFieldView.textField.text ?? ""))
    }

    @objc private func loginTapped() {
        viewModel.trigger(.loginTapped)
    }

    @objc private func googleTapped() {
        viewModel.trigger(.googleTapped)
    }

    @objc private func registerTapped() {
        viewModel.trigger(.registerTapped)
    }
}
