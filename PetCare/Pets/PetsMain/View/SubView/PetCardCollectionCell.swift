//
//  PetCardCollectionCell.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import UIKit

final class PetCardCollectionCell: UICollectionViewCell {
    static let identifier = "PetCardCollectionCell"

    private let petCard = PetCardRowView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupHierarchy()
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        petCard.prepareForReuse()
    }

    private func setupHierarchy() {
        contentView.addSubview(petCard)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            petCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            petCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            petCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func setData(pet: Pet, imageLoader: ImageLoader) {
        petCard.setData(pet: pet, imageLoader: imageLoader)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
