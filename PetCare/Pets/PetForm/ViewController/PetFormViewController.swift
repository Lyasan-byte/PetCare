//
//  PetFormViewController.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit
import PhotosUI
import Combine

final class PetFormViewController: UIViewController {
    private let petFormView = PetFormView()
    private let petFormViewModel: any PetFormViewModeling
    
    private var bag = Set<AnyCancellable>()
    private var selectedImage: UIImage?
    
    var onFinish: ((PetFormScreenResult) -> Void)?
    
    init(petFormViewModel: any PetFormViewModeling) {
        self.petFormViewModel = petFormViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupHierarchy()
        setupLayout()
        bindActions()
        bindViewModel()
        render(state: petFormViewModel.state)
    }
    
    private func setupHierarchy() {
        view.addSubview(petFormView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petFormView.topAnchor.constraint(equalTo: view.topAnchor),
            petFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindActions() {
        petFormView.photoPickerView.onPhotoPickerTap = { [weak self] in
            self?.openPhotoPicker()
        }
        
        petFormView.petNameTextField.onTextChanged = { [weak self] text in
            self?.petFormViewModel.trigger(.onChangeName(text))
        }
        
        petFormView.petWeightTextField.onTextChanged = { [weak self] text in
            self?.petFormViewModel.trigger(.onChangeWeight(text))
        }
        
        petFormView.petBreedTextField.onTextChanged = { [weak self] text in
            self?.petFormViewModel.trigger(.onChangeBreed(text))
        }
        
        petFormView.petDateOfBirthPicker.onDateChange = { [weak self] date in
            self?.petFormViewModel.trigger(.onChangeDate(date))
        }
        
        petFormView.isPublicProfileSwitch.onSwitchChange = { [weak self] isOn in
            self?.petFormViewModel.trigger(.onChangeIsPublicProfile(isOn))
        }
        
        petFormView.petGenderPicker.onValueChanged = { [weak self] index in
            self?.petFormViewModel.trigger(.onChangeGender(Gender.allCases[index]))
        }
        
        petFormView.petIconStatusPicker.onSelectStatus = { [weak self] status in
            self?.petFormViewModel.trigger(.onChangeIconStatus(status))
        }
        
        petFormView.noteTextView.onNoteChange = { [weak self] text in
            self?.petFormViewModel.trigger(.onChangeNote(text))
        }
        
        petFormView.saveButton.onTap = { [weak self] in
            self?.petFormViewModel.trigger(.onSave)
        }
        
        petFormView.deleteButton.addAction(UIAction { [weak self] _ in
            self?.petFormViewModel.trigger(.onDelete)
        }, for: .touchUpInside)
    }
    
    private func bindViewModel() {
        petFormViewModel.stateDidChange
            .sink { [weak self] in
                guard let self else { return }
                self.render(state: self.petFormViewModel.state)
            }
            .store(in: &bag)
        
        petFormViewModel.routePublisher
            .sink { [weak self] route in
                guard let self else { return }
                self.handle(route: route)
            }
            .store(in: &bag)
    }
    
    private func render(state: PetFormState) {
        title = petFormViewModel.state.title
        
        if petFormView.petNameTextField.textField.text != state.name {
            petFormView.petNameTextField.textField.text = state.name
        }
        
        if petFormView.petWeightTextField.textField.text != state.weightText {
            petFormView.petWeightTextField.textField.text = state.weightText
        }
        
        if petFormView.petBreedTextField.textField.text != state.breed {
            petFormView.petBreedTextField.textField.text = state.breed
        }
        
        if petFormView.noteTextView.noteTextView.text != state.note {
            petFormView.noteTextView.noteTextView.text = state.note
        }
            
        petFormView.petDateOfBirthPicker.datePicker.setDate(state.dateOfBirth, animated: true)
        petFormView.isPublicProfileSwitch.switchControl.setOn(state.isPublicProfile, animated: true)
        petFormView.petIconStatusPicker.select(state.iconStatus)
        
        let genderIndex = Gender.allCases.firstIndex(of: state.gender) ?? 0
        petFormView.petGenderPicker.setSelectedIndex(genderIndex)
        
        petFormView.saveButton.isEnabled = state.isSaveEnabled
        petFormView.deleteButton.isHidden = !state.showsDeleteButton
    }
    
    private func handle(route: PetFormRoute) {
        switch route {
        case .showDeleteConfirmation:
            showDeleteConfirmation()
        case .showErrorAlert(let message):
            showAlert(message)
        case .didSavePet(let pet):
            onFinish?(.saved(pet))
        case .didDeletePet:
            onFinish?(.deleted)
        case .close:
            onFinish?(.closed)
        }
    }
    
    private func showDeleteConfirmation() {
        let alert = UIAlertController(title: "Delete", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.petFormViewModel.trigger(.onConfirmDelete)
        }))
        
        present(alert, animated: true)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func openPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let photPickerViewController = PHPickerViewController(configuration: config)
        photPickerViewController.delegate = self
        present(photPickerViewController, animated: true)
    }
    
    private func configure() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetFormViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage,
                  error == nil else { return }
            DispatchQueue.main.async {
                self?.selectedImage = image
                self?.petFormView.photoPickerView.setImage(image)
            }
        }
    }   
}

enum PetFormScreenResult {
    case closed
    case saved(Pet)
    case deleted
}
