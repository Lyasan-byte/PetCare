//
//  PetFormView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class PetFormView: UIView {
    private let background = BackgroundView(backgroundColor: .white)
    private let scrollView = ScrollView()
    private let scrollContentView = UIView()
    
    let photoPickerView = PetImagePickerView()
    let petIconStatusPicker = PetIconStatusPicker()
    let petNameTextField = TextFieldView(title: "PET NAME", placeholder: "Cooper")
    
    let petBreedTextField = TextFieldView(title: "BREED", placeholder: "Golden Retriever", autocorrectionType: .default)
    let petWeightTextField = TextFieldView(title: "WEIGHT (KG)", placeholder: "28.5", keyboardType: .decimalPad)
    private lazy var petInfoStack = HStack(spacing: 10, arrangedSubviews: [petBreedTextField, petWeightTextField])
    
    let petDateOfBirthPicker = DatePickerView(title: "DATE OF BIRTH")
    
    private let genderPickerTitle = TextLabel(font: .systemFont(ofSize: 11, weight: .medium), text: "GENDER", textColor: Asset.petGray.color, textAlignment: .left)
    let petGenderPicker = SegmentedPickerView(items: Gender.allCases.map(\.rawValue))
    private lazy var genderStack = VStack(spacing: 10, arrangedSubviews: [genderPickerTitle, petGenderPicker])
    
    let noteTextView = NoteTextView()
    let isPublicProfileSwitch = SwitchOptionView(title: "Public Profile", subtitle: "Visible to local pet owners.", symbolName: "globe.americas.fill", iconColor: .black, circleColor: Asset.lightPink.color, circleSize: 45, iconSize: 20)
    let saveButton = PrimaryButton(title: "Save Changes")
    let deleteButton = PrimaryButton(title: "Delete Profile", backgroundColor: Asset.lightRed.color, textColor: Asset.redAccent.color)
    
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
