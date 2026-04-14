//
//  PetCardRowView.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit
import Combine

final class PetCardRowView: UIView {
    private let petImageView: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 35
        return imageView
    }()

    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)

    private lazy var hstack = HStack(
        spacing: 20,
        alignment: .top,
        arrangedSubviews: [petImageContainer, petInfoStack]
    )
    private lazy var petInfoStack = VStack(
        spacing: 10,
        arrangedSubviews: [
            petNameLabel,
            petBreedLabel,
            activityBadge
        ]
    )

    private var petStatusView = CircleIconView()
    private var petImageContainer = BackgroundView(backgroundColor: .clear, cornerRadius: 0)
    private var petNameLabel = TextLabel(font: .systemFont(ofSize: 16, weight: .bold), textAlignment: .left)
    private var petBreedLabel = TextLabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    
    private let activityBadge = PetCardBadge()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init(pet: Pet) {
        self.init(frame: .zero)
        configure(pet: pet)
    }

    func setData(pet: Pet, imageLoader: ImageLoader) {
        configure(pet: pet)
        petImageView.setImage(urlString: pet.photoUrl, imageLoader: imageLoader)
    }

    func prepareForReuse() {
        petImageView.cancelLoading()
        petImageView.image = UIImage(named: "defaultProfilePhoto")
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(hstack)
        petImageContainer.addSubview(petImageView)
        petImageContainer.addSubview(petStatusView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            hstack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            hstack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            hstack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            hstack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16),

            petImageContainer.widthAnchor.constraint(equalToConstant: 70),
            petImageContainer.heightAnchor.constraint(equalToConstant: 70),

            petImageView.topAnchor.constraint(equalTo: petImageContainer.topAnchor),
            petImageView.leadingAnchor.constraint(equalTo: petImageContainer.leadingAnchor),
            petImageView.trailingAnchor.constraint(equalTo: petImageContainer.trailingAnchor),
            petImageView.bottomAnchor.constraint(equalTo: petImageContainer.bottomAnchor),

            petStatusView.bottomAnchor.constraint(equalTo: petImageContainer.bottomAnchor, constant: -5),
            petStatusView.trailingAnchor.constraint(equalTo: petImageContainer.trailingAnchor)
        ])
    }

    private func configure(pet: Pet) {
        petNameLabel.text = pet.name
        petBreedLabel.text = "\(pet.breed) • \(pet.ageText)"
        petStatusView.configure(status: pet.iconStatus, circleSize: 22, iconSize: 10)
        petStatusView.isHidden = pet.iconStatus == .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
