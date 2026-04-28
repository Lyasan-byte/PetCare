//
//  WelcomeOnboardingHeroView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class WelcomeOnboardingHeroView: UIView {
    private let imageBadge = PetCardBadge(
        backgroundColor: Asset.petPurple.color,
        color: Asset.purpleAccentStatus.color,
        icon: "heart.fill",
        font: .systemFont(ofSize: 9, weight: .semibold),
        border: .tertiarySystemBackground,
        height: 40,
        iconSize: 10
    )
    private let petsImage = ImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    private func setupHierarchy() {
        addSubview(petsImage)
        addSubview(imageBadge)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            petsImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            petsImage.heightAnchor.constraint(equalToConstant: 220),

            imageBadge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            imageBadge.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }

    private func configure() {
        petsImage.image = UIImage(named: "onboardingPets")
        imageBadge.setText(text: L10n.WelcomeOnboarding.ImageBadge.text)
        imageBadge.setShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
