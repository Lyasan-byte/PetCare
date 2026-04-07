//
//  RegistrationCompletionView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import UIKit

final class RegistrationCompletionView: UIView {
    private let scrollView = ScrollView()
    private let scrollContentView = UIView()
    private let cardView = BackgroundView(
        backgroundColor: Asset.authCardViewColor.color,
        cornerRadius: 42
    )
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        view.isHidden = true
        return view
    }()
    private let loader = UIActivityIndicatorView(style: .medium)

    private lazy var contentStack = VStack(
        spacing: 20,
        arrangedSubviews: [
            photoPickerView,
            titleLabel,
            subtitleLabel,
            firstNameTextField,
            lastNameTextField,
            continueButton
        ]
    )

    let photoPickerView = UserProfileEditPhotoPickerView()
    private let titleLabel = TextLabel(
        font: .systemFont(ofSize: 38, weight: .bold),
        textColor: .label
    )
    private let subtitleLabel = TextLabel(
        font: .systemFont(ofSize: 17, weight: .regular),
        textColor: Asset.petGray.color
    )
    let firstNameTextField = TextFieldView(
        title: NSLocalizedString("user.profile.edit.first_name.title", comment: ""),
        placeholder: NSLocalizedString("user.profile.edit.first_name.placeholder", comment: "")
    )
    let lastNameTextField = TextFieldView(
        title: NSLocalizedString("user.profile.edit.last_name.title", comment: ""),
        placeholder: NSLocalizedString("user.profile.edit.last_name.placeholder", comment: "")
    )
    let continueButton = AuthPrimaryButton(
        title: NSLocalizedString("auth.registration_completion.button", comment: "")
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configureTexts(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    func setContinueButtonEnabled(_ isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        continueButton.alpha = isEnabled ? 1 : 0.7
    }

    func setLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading

        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }

        scrollView.isUserInteractionEnabled = !isLoading
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(cardView)
        cardView.addSubview(contentStack)
        addSubview(loadingOverlay)
        loadingOverlay.addSubview(loader)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            cardView.topAnchor.constraint(greaterThanOrEqualTo: scrollContentView.topAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -24),
            cardView.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor),

            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28),

            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }

    private func configure() {
        backgroundColor = .systemGroupedBackground
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = Asset.accentColor.color
        loader.hidesWhenStopped = true
        contentStack.setCustomSpacing(-16, after: photoPickerView)

        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        photoPickerView.hidesDescriptionLabels = true

        firstNameTextField.textField.autocapitalizationType = .words
        firstNameTextField.textField.textContentType = .givenName
        firstNameTextField.textField.returnKeyType = .next

        lastNameTextField.textField.autocapitalizationType = .words
        lastNameTextField.textField.textContentType = .familyName
        lastNameTextField.textField.returnKeyType = .done

        continueButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        photoPickerView.widthAnchor.constraint(equalTo: contentStack.widthAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
