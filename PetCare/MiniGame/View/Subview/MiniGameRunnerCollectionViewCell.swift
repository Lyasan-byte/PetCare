//
//  MiniGameRunnerCollectionViewCell.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameRunnerCollectionViewCell: UICollectionViewCell {
    static let identifier = "MiniGameRunnerCollectionViewCell"

    private let petImageBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.authCardViewColor.color
        view.layer.cornerRadius = 41
        return view
    }()

    private let petImage: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 37
        imageView.layer.borderWidth = 2.5
        return imageView
    }()

    private let imageDimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.24)
        view.layer.cornerRadius = 37
        view.isUserInteractionEnabled = false
        return view
    }()

    private let selectionBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.accentColor.color
        view.layer.cornerRadius = 11
        return view
    }()

    private let selectionIcon: ImageView = {
        let imageView = ImageView(tintColor: .white)
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        imageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
        return imageView
    }()

    private let petName = TextLabel(
        font: .systemFont(ofSize: 13, weight: .semibold),
        textColor: .label
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        contentView.addSubview(petImageBackground)
        petImageBackground.addSubview(petImage)
        petImageBackground.addSubview(imageDimView)
        petImageBackground.addSubview(selectionBadge)
        selectionBadge.addSubview(selectionIcon)
        contentView.addSubview(petName)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            petImageBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            petImageBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petImageBackground.widthAnchor.constraint(equalToConstant: 82),
            petImageBackground.heightAnchor.constraint(equalToConstant: 82),

            petImage.centerXAnchor.constraint(equalTo: petImageBackground.centerXAnchor),
            petImage.centerYAnchor.constraint(equalTo: petImageBackground.centerYAnchor),
            petImage.widthAnchor.constraint(equalToConstant: 74),
            petImage.heightAnchor.constraint(equalToConstant: 74),

            imageDimView.centerXAnchor.constraint(equalTo: petImage.centerXAnchor),
            imageDimView.centerYAnchor.constraint(equalTo: petImage.centerYAnchor),
            imageDimView.widthAnchor.constraint(equalTo: petImage.widthAnchor),
            imageDimView.heightAnchor.constraint(equalTo: petImage.heightAnchor),

            selectionBadge.trailingAnchor.constraint(equalTo: petImageBackground.trailingAnchor, constant: -2),
            selectionBadge.bottomAnchor.constraint(equalTo: petImageBackground.bottomAnchor, constant: -2),
            selectionBadge.widthAnchor.constraint(equalToConstant: 22),
            selectionBadge.heightAnchor.constraint(equalToConstant: 22),

            selectionIcon.centerXAnchor.constraint(equalTo: selectionBadge.centerXAnchor),
            selectionIcon.centerYAnchor.constraint(equalTo: selectionBadge.centerYAnchor),
            selectionIcon.widthAnchor.constraint(equalToConstant: 12),
            selectionIcon.heightAnchor.constraint(equalToConstant: 12),

            petName.topAnchor.constraint(equalTo: petImageBackground.bottomAnchor, constant: 10),
            petName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            petName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setData(pet: Pet, isSelected: Bool, imageLoader: ImageLoader) {
        petImage.setImage(urlString: pet.photoUrl, imageLoader: imageLoader)
        petName.text = pet.name
        petName.textColor = isSelected ? .label : Asset.petGray.color
        petName.font = .systemFont(ofSize: 13, weight: isSelected ? .semibold : .medium)

        let borderColor = isSelected
            ? Asset.accentColor.color
            : Asset.petLightGray.color.withAlphaComponent(0.85)
        petImage.layer.borderColor = borderColor.cgColor
        petImageBackground.layer.borderWidth = isSelected ? 2.5 : 0
        petImageBackground.layer.borderColor = Asset.lightGreen.color.cgColor
        selectionBadge.isHidden = !isSelected
        imageDimView.isHidden = isSelected
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
