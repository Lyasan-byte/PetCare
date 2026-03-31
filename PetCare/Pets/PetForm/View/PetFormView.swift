//
//  PetFormView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class PetFormView: UIView {
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let scrollView = ScrollView()
    private let scrollContentView = UIView()
    
    let photoPickerView = PetImagePickerView()
    let petIconStatusPicker = PetIconStatusPicker()
    let petNameTextField = TextFieldView(title: L10n.Pets.Form.Name.title, placeholder: L10n.Pets.Form.Name.placeholder)

    let petBreedTextField = TextFieldView(title: L10n.Pets.Form.Breed.title, placeholder: L10n.Pets.Form.Breed.placeholder, autocorrectionType: .default)
    let petWeightTextField = TextFieldView(title: L10n.Pets.Form.Weight.title, placeholder: L10n.Pets.Form.Weight.placeholder, keyboardType: .decimalPad)

    private lazy var petInfoStack = HStack(spacing: 10, arrangedSubviews: [petBreedTextField, petWeightTextField])
    
    let petDateOfBirthPicker = DatePickerView(title: L10n.Pets.Form.BirthDate.title)
    
    private let genderPickerTitle = TextLabel(font: .systemFont(ofSize: 11, weight: .medium), text: L10n.Pets.Form.Gender.title, textColor: Asset.petGray.color, textAlignment: .left)
    let petGenderPicker = SegmentedPickerView(items: Gender.allCases.map(\.rawValue))
    private lazy var genderStack = VStack(spacing: 10, arrangedSubviews: [genderPickerTitle, petGenderPicker])
    
    let noteTextView = NoteTextView()
    let isPublicProfileSwitch = SwitchOptionView(title: L10n.Pets.Form.PublicProfile.title, subtitle: L10n.Pets.Form.PublicProfile.subtitle, symbolName: "globe.americas.fill", iconColor: Asset.pinkAccent.color, circleColor: Asset.lightPink.color, circleSize: 45, iconSize: 20)
    let saveButton = PrimaryButton(title: L10n.Pets.Form.saveButton)
    let deleteButton = PrimaryButton(title: L10n.Pets.Form.deleteButton, backgroundColor: Asset.lightRed.color, textColor: Asset.redAccent.color)
    
    private lazy var contentStack = VStack(spacing: 16, arrangedSubviews: [photoPickerView, petIconStatusPicker, petNameTextField, petInfoStack, petDateOfBirthPicker, genderStack, noteTextView, isPublicProfileSwitch,
        saveButton, deleteButton])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
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
            
            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),
            
            petIconStatusPicker.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
