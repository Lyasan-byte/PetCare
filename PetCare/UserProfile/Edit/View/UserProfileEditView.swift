//
//  UserProfileEditView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class UserProfileEditView: UIView {
    private let loader = UIActivityIndicatorView()
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        view.isHidden = true
        return view
    }()
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let scrollView = ScrollView()
    private let scrollContentView = UIView()

    private lazy var contentStack = VStack(
        spacing: 18,
        arrangedSubviews: [
            photoPickerView,
            firstNameTextField,
            lastNameTextField,
            saveButton
        ]
    )

    let photoPickerView = UserProfileEditPhotoPickerView()
    let firstNameTextField = TextFieldView(
        title: NSLocalizedString("user.profile.edit.first_name.title", comment: ""),
        placeholder: NSLocalizedString("user.profile.edit.first_name.placeholder", comment: "")
    )
    let lastNameTextField = TextFieldView(
        title: NSLocalizedString("user.profile.edit.last_name.title", comment: ""),
        placeholder: NSLocalizedString("user.profile.edit.last_name.placeholder", comment: "")
    )
    let saveButton = PrimaryButton(
        title: NSLocalizedString("user.profile.edit.save_button", comment: ""),
        backgroundColor: Asset.accentColor.color,
        textColor: .white
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(loadingOverlay)
        loadingOverlay.addSubview(loader)

        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(background)
        background.addSubview(contentStack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            background.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 16),
            background.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            background.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            background.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -24),

            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
        ])
    }

    func setLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading

        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }

        loader.isHidden = !isLoading
        scrollView.isUserInteractionEnabled = !isLoading
        saveButton.isEnabled = !isLoading
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground

        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false

        loader.style = .medium
        loader.hidesWhenStopped = true

        firstNameTextField.textField.autocapitalizationType = .words
        firstNameTextField.textField.textContentType = .givenName
        firstNameTextField.textField.returnKeyType = .next

        lastNameTextField.textField.autocapitalizationType = .words
        lastNameTextField.textField.textContentType = .familyName
        lastNameTextField.textField.returnKeyType = .done
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
