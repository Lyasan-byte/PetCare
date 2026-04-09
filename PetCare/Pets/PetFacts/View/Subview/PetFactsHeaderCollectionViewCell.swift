//
//  PetFactsHeaderCollectionViewCell.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import UIKit

final class PetFactsHeaderCollectionViewCell: UICollectionViewCell {
    static let identifier = "PetFactsHeaderCollectionViewCell"
    
    private let breedTitle = TextLabel(
        font: .systemFont(
            ofSize: 13,
            weight: .medium
        ),
        text: L10n.Pets.Facts.breedInformation,
        textColor: Asset.accentColor.color
    )
    private let petBreed = TextLabel(font: .systemFont(ofSize: 22, weight: .bold), textColor: .label)
    private let petCharacteristic = TextLabel(
        font: .systemFont(
            ofSize: 16,
            weight: .regular
        ),
        textColor: Asset.petGray.color
    )
    
    private lazy var contentStack = VStack(
        spacing: 20,
        arrangedSubviews: [
            breedTitle,
            petBreed,
            petCharacteristic
        ]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        contentView.addSubview(contentStack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setData(breed: String, petCharacteristic: String) {
        self.petBreed.text = breed
        self.petCharacteristic.text = petCharacteristic
        self.petCharacteristic.isHidden = petCharacteristic.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
