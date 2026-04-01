//
//  RegisterView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 28.03.2026.
//

import Foundation
import UIKit

final class RegisterView: UIView {

    let headerView = AuthHeaderView()
    let emailFieldView = AuthTextFieldView(
        title: NSLocalizedString("auth.email.title", comment: ""),
        placeholder: NSLocalizedString("auth.email.placeholder", comment: "")
    )
    let passwordFieldView = AuthTextFieldView(
        title: NSLocalizedString("auth.password.title", comment: ""),
        placeholder: NSLocalizedString("auth.password.placeholder", comment: ""),
        isSecure: true
    )
    let confirmPasswordFieldView = AuthTextFieldView(
        title: NSLocalizedString("auth.confirm_password.title", comment: ""),
        placeholder: NSLocalizedString("auth.confirm_password.placeholder", comment: ""),
        isSecure: true
    )

    let registerButton = UIButton(type: .system)
    let dividerView = AuthDividerView()
    let googleButton = UIButton(type: .system)
    let switchButton = UIButton(type: .system)
    let switchWrapperView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    let switchContainerView = UIStackView()
    let switchTitleLabel = UILabel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupActionsStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String) {
        headerView.configure(title: title, subtitle: subtitle)
    }

    func setRegisterButtonEnabled(_ isEnabled: Bool) {
        registerButton.isEnabled = isEnabled
        registerButton.alpha = isEnabled ? 1 : 0.7
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        registerButton.isEnabled = !isLoading
        googleButton.isEnabled = !isLoading
        switchButton.isEnabled = !isLoading
    }

    private func setup() {
        backgroundColor = .systemGroupedBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            headerView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -24),

            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 40
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)

        setupCardContent()
    }

    private func setupCardContent() {
        setupRegisterButton()
        setupDividerView()
        setupGoogleButton()
        setupSwitchSection()
        setupActivityIndicator()

        let fieldsStack = makeFieldsStack()
        cardView.addSubview(fieldsStack)

        NSLayoutConstraint.activate([
            fieldsStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            fieldsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            fieldsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            fieldsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),

            switchContainerView.centerXAnchor.constraint(equalTo: switchWrapperView.centerXAnchor),
            switchContainerView.topAnchor.constraint(equalTo: switchWrapperView.topAnchor),
            switchContainerView.bottomAnchor.constraint(equalTo: switchWrapperView.bottomAnchor),

            emailFieldView.heightAnchor.constraint(equalToConstant: 80),
            passwordFieldView.heightAnchor.constraint(equalToConstant: 80),
            confirmPasswordFieldView.heightAnchor.constraint(equalToConstant: 80),
            registerButton.heightAnchor.constraint(equalToConstant: 52),
            googleButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupRegisterButton() {
        let arrowImage = UIImage(systemName: "arrow.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )

        registerButton.configuration = .filled()
        registerButton.configuration?.title = NSLocalizedString("auth.register.button", comment: "")
        registerButton.configuration?.image = arrowImage
        registerButton.configuration?.imagePlacement = .trailing
        registerButton.configuration?.imagePadding = 8
        registerButton.configuration?.cornerStyle = .capsule
        registerButton.configuration?.baseBackgroundColor = Asset.accentColor.color
        registerButton.configuration?.baseForegroundColor = .white
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        registerButton.layer.cornerRadius = 28
        registerButton.clipsToBounds = true
    }

    private func setupDividerView() {
        dividerView.configure(text: NSLocalizedString("auth.or", comment: ""))
    }

    private func setupGoogleButton() {
        googleButton.configuration = .plain()
        googleButton.backgroundColor = .white
        googleButton.configuration?.cornerStyle = .capsule
        googleButton.configuration?.imagePadding = 8
        googleButton.layer.cornerRadius = 28
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = Asset.petGray.color.cgColor
        googleButton.setTitle(NSLocalizedString("auth.google.button", comment: ""), for: .normal)
        googleButton.setTitleColor(.label, for: .normal)
        googleButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        let googleImage = UIImage(named: "google_icon")
        let resizedImage = googleImage?.preparingThumbnail(of: CGSize(width: 20, height: 20))

        googleButton.configuration?.image = resizedImage
        googleButton.tintColor = nil
        googleButton.semanticContentAttribute = .forceLeftToRight
        googleButton.imageView?.contentMode = .scaleAspectFit
    }

    private func setupSwitchSection() {
        switchTitleLabel.text = NSLocalizedString("auth.register.switch_prefix", comment: "")
        switchTitleLabel.textColor = Asset.petGray.color
        switchTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)

        switchButton.setTitle(NSLocalizedString("auth.register.switch_action", comment: ""), for: .normal)
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
            confirmPasswordFieldView,
            registerButton,
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
        passwordFieldView.textField.returnKeyType = .next
        confirmPasswordFieldView.textField.returnKeyType = .done
    }
}
