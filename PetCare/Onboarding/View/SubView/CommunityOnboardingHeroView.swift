//
//  CommunityOnboardingHeroView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class CommunityOnboardingHeroView: UIView {
    private let communityIcon = CircleIconView(
        symbolName: "person.3.fill",
        iconColor: .black,
        circleColor: Asset.petGreen.color.withAlphaComponent(0.8),
        circleSize: 120,
        iconSize: 46,
        weight: .semibold
    )
    private let gameBadge = CircleIconView(
        symbolName: "heart.fill",
        iconColor: Asset.redAccent.color,
        circleColor: Asset.lightRed.color,
        circleSize: 45,
        iconSize: 20,
        weight: .semibold,
        borderColor: Asset.lightPink.color,
        shadowColor: UIColor.black.withAlphaComponent(0.15)
    )
    private lazy var communityTile = OnboardingFeatureTileView(
        backgroundColor: Asset.petGreenAction.color,
        iconBackgroundColor: Asset.lightGreen.color,
        iconTintColor: Asset.accentColor.color,
        titleColor: Asset.accentColor.color,
        iconName: "globe.americas.fill",
        title: L10n.OnboardingCommunity.Card.PublicPets.title.uppercased(with: Locale.current)
    )
    private lazy var miniGameTile = OnboardingFeatureTileView(
        backgroundColor: Asset.petPurpleAction.color,
        iconBackgroundColor: Asset.lightPurple.color,
        iconTintColor: Asset.purpleAccent.color,
        titleColor: Asset.purpleAccent.color,
        iconName: "gamecontroller.fill",
        title: NSLocalizedString("mini.game.screen.title", comment: "").uppercased(with: Locale.current)
    )
    private lazy var bottomRow = HStack(
        spacing: 12,
        distribution: .fillEqually,
        arrangedSubviews: [communityTile, miniGameTile]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        addSubview(communityIcon)
        addSubview(gameBadge)
        addSubview(bottomRow)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            communityIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            communityIcon.topAnchor.constraint(equalTo: topAnchor, constant: 4),

            gameBadge.centerYAnchor.constraint(equalTo: communityIcon.bottomAnchor, constant: -6),
            gameBadge.trailingAnchor.constraint(equalTo: communityIcon.trailingAnchor, constant: 4),

            bottomRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomRow.topAnchor.constraint(equalTo: communityIcon.bottomAnchor, constant: 34),
            bottomRow.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            bottomRow.heightAnchor.constraint(equalToConstant: 108),

            communityTile.heightAnchor.constraint(equalToConstant: 108),
            miniGameTile.heightAnchor.constraint(equalToConstant: 108)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
