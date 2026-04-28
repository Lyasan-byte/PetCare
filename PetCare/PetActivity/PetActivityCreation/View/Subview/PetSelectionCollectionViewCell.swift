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
    
    private let selectionBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.accentColor.color
        view.layer.cornerRadius = 10.5
        return view
    }()
    
    private let selectionIcon: ImageView = {
        let imageView = ImageView(tintColor: .white)
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        imageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
        return imageView
    }()
    
    private let imageContainer = UIView()

    private let petName = TextLabel(
        font: .systemFont(
            ofSize: 13,
            weight: .medium
        )
    )

    private lazy var contentStack = VStack(
        spacing: 5,
        arrangedSubviews: [imageContainer, petName]
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
        imageContainer.addSubview(petImage)
        imageContainer.addSubview(selectionBadge)
        selectionBadge.addSubview(selectionIcon)
    }

    private func setupLayout() {
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageContainer.heightAnchor.constraint(equalToConstant: 65),
            imageContainer.widthAnchor.constraint(equalToConstant: 65),

            petImage.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            petImage.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            petImage.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            petImage.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            selectionBadge.widthAnchor.constraint(equalToConstant: 21),
            selectionBadge.heightAnchor.constraint(equalToConstant: 21),
            selectionBadge.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            selectionBadge.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),

            selectionIcon.widthAnchor.constraint(equalToConstant: 11),
            selectionIcon.heightAnchor.constraint(equalToConstant: 11),
            selectionIcon.centerXAnchor.constraint(equalTo: selectionBadge.centerXAnchor),
            selectionIcon.centerYAnchor.constraint(equalTo: selectionBadge.centerYAnchor)
        ])
    }

    func setData(pet: Pet, isSelected: Bool, imageLoader: ImageLoader) {
        petImage.setImage(urlString: pet.photoUrl, imageLoader: imageLoader)
        petName.text = pet.name

        petImage.layer.borderColor = isSelected ? Asset.accentColor.color.cgColor : UIColor.clear.cgColor
        petImage.layer.borderWidth = isSelected ? 2 : 0
        petName.textColor = isSelected ? Asset.accentColor.color : UIColor.petGray
        
        selectionBadge.isHidden = !isSelected
        selectionIcon.isHidden = !isSelected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
