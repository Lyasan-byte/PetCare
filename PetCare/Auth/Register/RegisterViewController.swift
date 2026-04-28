//
//  RegisterViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 28.03.2026.
//

import Foundation
import UIKit
import Combine

final class RegisterViewController: UIViewController {
    private let viewModel: RegisterViewModel
    private let contentView = RegisterView()
    private var bag = Set<AnyCancellable>()

    init(viewModel: RegisterViewModel) {
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
        setupKeyboardDismiss()
        viewModel.trigger(.onDidLoad)
    }

    private func bind() {
        viewModel.stateDidChange
            .sink { [weak self] in
                self?.render()
            }
            .store(in: &bag)
    }

    private func setupActions() {
        contentView.emailFieldView.textField.addTarget(
            self,
            action: #selector(emailChanged),
            for: .editingChanged
        )
        contentView.passwordFieldView.textField.addTarget(
            self,
            action: #selector(passwordChanged),
            for: .editingChanged
        )
        contentView.confirmPasswordFieldView.textField.addTarget(
            self,
            action: #selector(confirmPasswordChanged),
            for: .editingChanged
        )
        contentView.onHelpTap = { [weak self] in
            self?.viewModel.trigger(.helpTapped)
        }
        contentView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        contentView.googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        contentView.switchButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            contentView.setLoading(true)

        case .content(let content):
            contentView.configureHeaderView(title: content.title, subtitle: content.subtitle)
            contentView.emailFieldView.textField.text = content.email
            contentView.passwordFieldView.textField.text = content.password
            contentView.confirmPasswordFieldView.textField.text = content.confirmPassword
            contentView.setRegisterButtonEnabled(content.isRegisterEnabled)
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

    @objc private func confirmPasswordChanged() {
        viewModel.trigger(.confirmPasswordChanged(contentView.confirmPasswordFieldView.textField.text ?? ""))
    }

    @objc private func registerTapped() {
        viewModel.trigger(.registerTapped)
    }

    @objc private func googleTapped() {
        viewModel.trigger(.googleTapped)
    }

    @objc private func loginTapped() {
        viewModel.trigger(.loginTapped)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
