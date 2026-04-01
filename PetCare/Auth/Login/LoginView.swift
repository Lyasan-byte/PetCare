//
//  LoginView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 27.03.2026.
//

import Foundation
import UIKit

final class LoginView: UIView {

    private let containerView = AuthContainerView(headerBottomSpacing: -60)
    let emailFieldView = AuthTextFieldView(
        title: NSLocalizedString("auth.email.title", comment: ""),
        placeholder: NSLocalizedString("auth.email.placeholder", comment: "")
    )
    let passwordFieldView = AuthTextFieldView(
        title: NSLocalizedString("auth.password.title", comment: ""),
        placeholder: NSLocalizedString("auth.password.placeholder", comment: ""),
        isSecure: true
    )

    let loginButton = AuthPrimaryButton(title: NSLocalizedString("auth.login.button", comment: ""))
    let dividerView = AuthDividerView()
    let googleButton = AuthGoogleButton()
    let switchButton = UIButton(type: .system)
    let switchWrapperView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    let switchContainerView = UIStackView()
    let switchTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupActionsStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHeaderView(title: String, subtitle: String) {
        containerView.configureHeaderView(title: title, subtitle: subtitle)
    }

    func setLoginButtonEnabled(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
        loginButton.alpha = isEnabled ? 1 : 0.7
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        loginButton.isEnabled = !isLoading
        googleButton.isEnabled = !isLoading
        switchButton.isEnabled = !isLoading
    }

    private func setup() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupCardContent()
    }

    private func setupCardContent() {
        setupDividerView()
        setupSwitchSection()
        setupActivityIndicator()

        let fieldsStack = makeFieldsStack()
        containerView.addCardContentView(fieldsStack)

        NSLayoutConstraint.activate([
            switchContainerView.centerXAnchor.constraint(equalTo: switchWrapperView.centerXAnchor),
            switchContainerView.topAnchor.constraint(equalTo: switchWrapperView.topAnchor),
            switchContainerView.bottomAnchor.constraint(equalTo: switchWrapperView.bottomAnchor),

            emailFieldView.heightAnchor.constraint(equalToConstant: 80),
            passwordFieldView.heightAnchor.constraint(equalToConstant: 80),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            googleButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupDividerView() {
        dividerView.configure(text: NSLocalizedString("auth.or", comment: ""))
    }

    private func setupSwitchSection() {
        switchTitleLabel.text = NSLocalizedString("auth.login.switch_prefix", comment: "")
        switchTitleLabel.textColor = Asset.petGray.color
        switchTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)

        switchButton.setTitle(NSLocalizedString("auth.login.switch_action", comment: ""), for: .normal)
        switchButton.setTitleColor(Asset.accentColor.color, for: .normal)
        switchButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)

        switchContainerView.axis = .horizontal
        switchContainerView.alignment = .center
        switchContainerView.distribution = .fill
        switchContainerView.spacing = 6
        switchContainerView.translatesAutoresizingMaskIntoConstraints = false
        switchContainerView.addArrangedSubview(switchTitleLabel)
        switchContainerView.addArrangedSubview(switchButton)
        switchWrapperView.addSubview(switchContainerView)

        switchTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        switchTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        switchButton.setContentHuggingPriority(.required, for: .horizontal)
        switchButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        switchContainerView.setContentHuggingPriority(.required, for: .horizontal)
        switchContainerView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Asset.accentColor.color
    }

    private func makeFieldsStack() -> UIStackView {
        let fieldsStack = UIStackView(arrangedSubviews: [
            emailFieldView,
            passwordFieldView,
            loginButton,
            dividerView,
            googleButton,
            switchWrapperView,
            activityIndicator
        ])
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 22
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        return fieldsStack
    }

    private func setupActionsStyle() {
        emailFieldView.textField.returnKeyType = .next
        passwordFieldView.textField.returnKeyType = .done
    }
}
