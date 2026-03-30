//
//  PetProfileView.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileView: UIView {
    private let petCardView = PetProfileCardView()
    
    private let petNoteView = PetProfileNoteView()
    
    let createActivityButton = PrimaryButton(title: "Create Activity")
    
    let editButton = PetProfileButton(text: "Edit Profile", image: "pencil", textColor: .black, backgroundColor: Asset.petGray.color.withAlphaComponent(0.3))
    let analyticsButton = PetProfileButton(text: "Analytics", image: "chart.bar.fill", textColor: Asset.pinkAccent.color, backgroundColor: Asset.petPink.color.withAlphaComponent(0.7))
    private lazy var buttonsStack = HStack(spacing: 10, alignment: .center, distribution: .fillEqually, arrangedSubviews: [editButton, analyticsButton])
    
    private lazy var buttonsContainer = VStack(spacing: 16, arrangedSubviews: [createActivityButton, buttonsStack])
    
    private lazy var viewContainer = VStack(spacing: 30, arrangedSubviews: [petCardView, petNoteView, buttonsContainer])
    
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
        addSubview(viewContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: topAnchor),
            viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
//            createActivityButton.topAnchor.constraint(equalTo: petNoteView.bottomAnchor, constant: 16)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
