//
//  RegistrationCompletionViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import UIKit
import PhotosUI
import Combine

final class RegistrationCompletionViewController: UIViewController {
    private let viewModel: any RegistrationCompletionViewModeling
    private let imageLoader: ImageLoader
    private let contentView = RegistrationCompletionView()
    private var bag = Set<AnyCancellable>()

    init(viewModel: any RegistrationCompletionViewModeling, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
        bindViewModel()
        setupKeyboardDismiss()
        render()
        viewModel.trigger(.onDidLoad)
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

        contentView.continueButton.addTarget(
            self,
            action: #selector(saveTapped),
            for: .touchUpInside
        )

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

    private func bindViewModel() {
        viewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.render()
            }
            .store(in: &bag)
    }

    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            renderLoading()
        case .content(let displayData):
            renderContent(displayData)
        case .error(let message):
            renderError(message)
        }
    }

    private func renderLoading() {
        contentView.configureTexts(
            title: NSLocalizedString("auth.registration_completion.title", comment: ""),
            subtitle: NSLocalizedString("auth.registration_completion.subtitle", comment: "")
        )
        contentView.setContinueButtonEnabled(false)
        contentView.setLoading(true)
    }

    private func renderContent(_ displayData: RegistrationCompletionDisplayData) {
        contentView.configureTexts(title: displayData.title, subtitle: displayData.subtitle)

        if contentView.firstNameTextField.textField.text != displayData.firstName {
            contentView.firstNameTextField.textField.text = displayData.firstName
        }

        if contentView.lastNameTextField.textField.text != displayData.lastName {
            contentView.lastNameTextField.textField.text = displayData.lastName
        }

        contentView.setContinueButtonEnabled(displayData.isSaveEnabled)
        contentView.setLoading(false)
        renderPhoto(displayData)
    }

    private func renderError(_ message: String) {
        contentView.configureTexts(
            title: NSLocalizedString("auth.registration_completion.title", comment: ""),
            subtitle: NSLocalizedString("auth.registration_completion.subtitle", comment: "")
        )
        contentView.setLoading(false)
        renderErrorIfNeeded(message)
    }

    private func renderPhoto(_ displayData: RegistrationCompletionDisplayData) {
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

    private func renderErrorIfNeeded(_ message: String) {
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

    @objc private func saveTapped() {
        view.endEditing(true)
        viewModel.trigger(.onSave)
    }

    @objc private func focusLastNameField() {
        contentView.lastNameTextField.textField.becomeFirstResponder()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegistrationCompletionViewController: PHPickerViewControllerDelegate {
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
