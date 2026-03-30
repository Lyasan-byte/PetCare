//
//  LoginView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 27.03.2026.
//

import Foundation
import UIKit

final class LoginView: UIView {

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

    let loginButton = UIButton(type: .system)
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
            headerView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -80),

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
        let arrowImage = UIImage(systemName: "arrow.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )

        loginButton.configuration = .filled()
        loginButton.configuration?.title = NSLocalizedString("auth.login.button", comment: "")
        loginButton.configuration?.image = arrowImage
        loginButton.configuration?.imagePlacement = .trailing
        loginButton.configuration?.imagePadding = 8
        loginButton.configuration?.cornerStyle = .capsule
        loginButton.configuration?.baseBackgroundColor = Asset.accentColor.color
        loginButton.configuration?.baseForegroundColor = .white
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        loginButton.layer.cornerRadius = 28
        loginButton.clipsToBounds = true

        dividerView.configure(text: NSLocalizedString("auth.or", comment: ""))

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
        switchContainerView.translatesAutoresizingMaskIntoConstraints = false
        switchWrapperView.addSubview(switchContainerView)
        
        switchTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        switchTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        switchButton.setContentHuggingPriority(.required, for: .horizontal)
        switchButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        switchContainerView.setContentHuggingPriority(.required, for: .horizontal)
        switchContainerView.setContentCompressionResistancePriority(.required, for: .horizontal)


        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Asset.accentColor.color

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
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            googleButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupActionsStyle() {
        emailFieldView.textField.returnKeyType = .next
        passwordFieldView.textField.returnKeyType = .done
    }
}
