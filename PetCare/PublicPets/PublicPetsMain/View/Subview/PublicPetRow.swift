//
//  PublicPetRow.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class PublicPetRow: UIView {
    private let petImage: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    private let petNote: TextLabel = {
        let label = TextLabel(
            font: .systemFont(ofSize: 14, weight: .regular),
            textColor: Asset.petGray.color,
            textAlignment: .left
        )
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let petName = TextLabel(
        font: .systemFont(ofSize: 18, weight: .medium),
        textAlignment: .left
    )
    private let petGender = TextLabel(
        font: .systemFont(ofSize: 16, weight: .medium),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    private let petBreed = TextLabel(
        font: .systemFont(ofSize: 15, weight: .regular),
        textColor: Asset.accentColor.color,
        textAlignment: .left
    )
    private let petGameScore = PetCardBadge(
        backgroundColor: Asset.lightPurple.color,
        color: Asset.purpleAccent.color,
        icon: "gamecontroller.fill",
        height: 30,
        iconSize: 16
    )

    private lazy var petNameGenderStack = HStack(spacing: 10, arrangedSubviews: [petName, petGender])
    private lazy var petGameScoreStack = HStack(
        spacing: 0,
        distribution: .equalSpacing,
        arrangedSubviews: [petNameGenderStack, petGameScore]
    )
    private lazy var petInfoStack = VStack(spacing: 0, arrangedSubviews: [petGameScoreStack, petBreed])
    private lazy var contentStack = VStack(
        spacing: 16,
        arrangedSubviews: [petInfoStack, petNote]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func setData(pet: Pet, imageLoader: ImageLoader) {
        petName.text = pet.name
        petGender.text = pet.gender.title
        petBreed.text = pet.breed
        petGameScore.setText(text: PetScoreFormatter.string(for: pet.gameScore))

        petNote.text = pet.note
        petNote.isHidden = pet.note.isEmpty

        petImage.setImage(urlString: pet.photoUrl, imageLoader: imageLoader)
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(petImage)
        background.addSubview(contentStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            petImage.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            petImage.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            petImage.widthAnchor.constraint(equalToConstant: 90),
            petImage.heightAnchor.constraint(equalToConstant: 90),

            contentStack.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
