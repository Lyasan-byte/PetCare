//
//  PetSelectionCollectionViewCell.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class PetSelectionCollectionViewCell: UICollectionViewCell {
    static let identifier = "PetSelectionCollectionViewCell"
    
    private let petImage: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 32.5
        return imageView
    }()
    
    private let petName = TextLabel(
        font: .systemFont(
            ofSize: 13,
            weight: .medium
        )
    )
    
    private lazy var contentStack = VStack(spacing: 5, arrangedSubviews: [petImage, petName])
    
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
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            petImage.heightAnchor.constraint(equalToConstant: 65),
            petImage.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    func setData(pet: Pet, isSelected: Bool, imageLoader: ImageLoader) {
        petImage.setImage(urlString: pet.photoUrl, imageLoader: imageLoader)
        petName.text = pet.name
        
        petImage.layer.borderColor = isSelected ? Asset.accentColor.color.cgColor : UIColor.clear.cgColor
        petImage.layer.borderWidth = isSelected ? 1.4 : 0
        petName.textColor = isSelected ? Asset.accentColor.color : UIColor.petGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
