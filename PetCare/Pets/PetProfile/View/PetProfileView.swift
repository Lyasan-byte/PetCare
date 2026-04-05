//
//  PetProfileView.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileView: UIView {
    let createActivityButton = PrimaryButton(title: L10n.Pets.Profile.createActivityButton, shadowColor: Asset.primaryGreen.color)
    let editButton = PetProfileButton(text:  L10n.Pets.Profile.editButton, image: "pencil", textColor: .label, backgroundColor: .tertiarySystemBackground)
    let analyticsButton = PetProfileButton(text: L10n.Pets.Profile.analyticsButton, image: "chart.bar.fill", textColor: Asset.pinkAccent.color, backgroundColor: Asset.lightPink.color)
    
    private let scrollView = ScrollView()
    private let petCardView = PetProfileCardView()
    private let petNoteView = PetProfileNoteView()
    private lazy var buttonsStack = HStack(spacing: 10, alignment: .center, distribution: .fillEqually, arrangedSubviews: [editButton, analyticsButton])
    private lazy var buttonsContainer = VStack(spacing: 16, arrangedSubviews: [createActivityButton, buttonsStack])
    
    private lazy var scrollContent = VStack(spacing: 30, arrangedSubviews: [petCardView, petNoteView])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setPetData(_ pet: Pet, imageLoader: ImageLoader) {
        petCardView.setData(isPublic: false, pet: pet, imageLoader: imageLoader)
        petNoteView.noteText.text = pet.note
        
        petNoteView.isHidden = pet.note.isEmpty
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(buttonsContainer)
        scrollView.addSubview(scrollContent)
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
            
            scrollContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
