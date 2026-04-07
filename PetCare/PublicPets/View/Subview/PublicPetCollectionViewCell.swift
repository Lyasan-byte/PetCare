//
//  PublicPetCollectionViewCell.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class PublicPetCollectionViewCell: UICollectionViewCell {
    static let identifier = "PublicPetCollectionViewCell"
    
    private let petCard = PublicPetRow()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setData(pet: Pet, imageLoader: ImageLoader) {
        petCard.setData(pet: pet, imageLoader: imageLoader)
    }
    
    private func setupHierarchy() {
        contentView.addSubview(petCard)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            petCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            petCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
