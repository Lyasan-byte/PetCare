//
//  UserProfileEditViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit
import PhotosUI
import Combine

final class UserProfileEditViewController: UIViewController {
    private let viewModel: any UserProfileEditViewModeling
    private let imageLoader: ImageLoader
    private let contentView = UserProfileEditView()
    private var bag = Set<AnyCancellable>()

    init(viewModel: any UserProfileEditViewModeling, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        configure()
        bindActions()
        bindViewModel()
        render(state: viewModel.state)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func bindActions() {
        contentView.photoPickerView.onTap = { [weak self] in
            self?.openPhotoPicker()
        }

        contentView.firstNameTextField.onTextChanged = { [weak self] text in
            self?.viewModel.trigger(.onChangeFirstName(text))
        }

        contentView.lastNameTextField.onTextChanged = { [weak self] text in
            self?.viewModel.trigger(.onChangeLastName(text))
        }

        contentView.saveButton.onTap = { [weak self] in
            self?.view.endEditing(true)
            self?.viewModel.trigger(.onSave)
        }

        contentView.firstNameTextField.textField.addTarget(
            self,
            action: #selector(focusLastNameField),
            for: .editingDidEndOnExit
        )
        contentView.lastNameTextField.textField.addTarget(
            self,
            action: #selector(dismissKeyboard),
            for: .editingDidEndOnExit
        )
    }

    private func setupHierarchy() {
        view.addSubview(contentView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configure() {
        view.backgroundColor = .secondarySystemBackground
    }

    private func bindViewModel() {
        viewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(state: self.viewModel.state)
            }
            .store(in: &bag)
    }

    private func render(state: UserProfileEditState) {
        switch state {
        case .loading:
            title = NSLocalizedString("user.profile.edit.navigation.title", comment: "")
            contentView.setLoading(true)
        case .content(let displayData):
            renderContent(displayData)
        case .error(let message):
            title = NSLocalizedString("user.profile.edit.navigation.title", comment: "")
            contentView.setLoading(false)
            renderErrorIfNeeded(message)
        }
    }

    private func renderContent(_ displayData: UserProfileEditDisplayData) {
        title = displayData.title

        if contentView.firstNameTextField.textField.text != displayData.firstName {
            contentView.firstNameTextField.textField.text = displayData.firstName
        }

        if contentView.lastNameTextField.textField.text != displayData.lastName {
            contentView.lastNameTextField.textField.text = displayData.lastName
        }

        contentView.saveButton.isEnabled = displayData.isSaveEnabled
        contentView.saveButton.alpha = displayData.isSaveEnabled ? 1 : 0.6
        contentView.setLoading(displayData.isSaving)

        renderPhoto(displayData)
    }

    private func renderPhoto(_ displayData: UserProfileEditDisplayData) {
        if let data = displayData.selectedPhotoData,
           let image = UIImage(data: data) {
            contentView.photoPickerView.setImage(image)
            return
        }

        if let urlString = displayData.existingPhotoUrl,
           !urlString.isEmpty {
            contentView.photoPickerView.setRemoteImage(
                urlString: urlString,
                imageLoader: imageLoader
            )
            return
        }

        contentView.photoPickerView.resetImage()
    }

    private func renderErrorIfNeeded(_ message: String?) {
        guard let message else { return }
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(
            title: NSLocalizedString("common.error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("common.ok", comment: ""),
                style: .default
            ) { [weak self] _ in
                self?.viewModel.trigger(.onDismissAlert)
            }
        )
        present(alert, animated: true)
    }

    private func openPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1

        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = self
        present(photoPickerViewController, animated: true)
    }

    @objc private func focusLastNameField() {
        contentView.lastNameTextField.textField.becomeFirstResponder()
    }

    @objc private func dismissKeyboard() {
        contentView.lastNameTextField.textField.resignFirstResponder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }
        guard provider.hasItemConformingToTypeIdentifier("public.image") else { return }

        provider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak self] data, error in
            guard let self, let data, error == nil else { return }
            guard let image = UIImage(data: data),
                  let compressedData = image.jpegData(compressionQuality: 0.7) else {
                return
            }

            DispatchQueue.main.async {
                self.viewModel.trigger(.onPickPhoto(compressedData))
            }
        }
    }
}
