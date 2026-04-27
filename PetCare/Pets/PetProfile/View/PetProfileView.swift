//
//  PetProfileView.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileView: UIView {
    var onBreedTap: (() -> Void)?

    private let birthdayBadge = PetCardBadge(
        backgroundColor: Asset.yellowBackground.color,
        color: Asset.midPurple.color,
        icon: "birthday.cake.fill",
        text: "Happy birthday!",
        font: .systemFont(ofSize: 14, weight: .medium),
        height: 38
    )
    
//    private let birthdayBadge = PetCardBadge(
//        backgroundColor: Asset.backgroundLightPink.color,
//        color: Asset.pinkAccent.color,
//        icon: "birthday.cake.fill",
//        text: L10n.PetProfile.BirthdayBadge.text,
//        font: .systemFont(ofSize: 14, weight: .medium),
//        shadow: Asset.yellowBackground.color,
//        height: 38
//    )
    
    private let profileCardContainer = UIView()
    
    let createActivityButton = PrimaryButton(
        title: L10n.Pets.Profile.createActivityButton,
        shadowColor: Asset.primaryGreen.color
    )

    let editButton = PetProfileButton(
        text: L10n.Pets.Profile.editButton,
        image: "pencil",
        textColor: .label,
        backgroundColor: .tertiarySystemBackground
    )

    let analyticsButton = PetProfileButton(
        text: L10n.Pets.Profile.analyticsButton,
        image: "chart.bar.fill",
        textColor: Asset.pinkAccent.color,
        backgroundColor: Asset.lightPink.color
    )

    private let scrollView = ScrollView()
    private let petCardView = PetProfileCardView()
    private let petNoteView = PetProfileNoteView()

    private lazy var buttonsStack = HStack(
        spacing: 10,
        alignment: .center,
        distribution: .fillEqually,
        arrangedSubviews: [
            editButton,
            analyticsButton
        ]
    )

    private lazy var buttonsContainer = VStack(
        spacing: 16,
        arrangedSubviews: [
            createActivityButton,
            buttonsStack
        ]
    )

    private lazy var scrollContent = VStack(
        spacing: 30,
        arrangedSubviews: [
            profileCardContainer,
            petNoteView
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        bindAction()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func bindAction() {
        petCardView.onBreedTap = { [weak self] in
            self?.onBreedTap?()
        }
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(buttonsContainer)
        scrollView.addSubview(scrollContent)
        profileCardContainer.addSubview(petCardView)
        profileCardContainer.addSubview(birthdayBadge)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: -16),

            scrollContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            scrollContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            petCardView.topAnchor.constraint(equalTo: profileCardContainer.topAnchor),
            petCardView.leadingAnchor.constraint(equalTo: profileCardContainer.leadingAnchor),
            petCardView.trailingAnchor.constraint(equalTo: profileCardContainer.trailingAnchor),
            petCardView.bottomAnchor.constraint(equalTo: profileCardContainer.bottomAnchor),
            
            birthdayBadge.topAnchor.constraint(equalTo: profileCardContainer.topAnchor, constant: -8),
            birthdayBadge.trailingAnchor.constraint(equalTo: profileCardContainer.trailingAnchor)
        ])
    }

    func setPetData(_ pet: Pet, imageLoader: ImageLoader) {
        petCardView.setData(isPublic: false, pet: pet, imageLoader: imageLoader)
        petNoteView.noteText.text = pet.note

        petNoteView.isHidden = pet.note.isEmpty
        birthdayBadge.isHidden = !pet.hasBirthday
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
