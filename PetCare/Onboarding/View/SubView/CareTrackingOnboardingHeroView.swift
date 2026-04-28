//
//  CareTrackingOnboardingHeroView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class CareTrackingOnboardingHeroView: UIView {
    private lazy var walkTile = OnboardingFeatureTileView(
        backgroundColor: Asset.petGreenAction.color,
        iconBackgroundColor: Asset.lightGreen.color,
        iconTintColor: Asset.accentColor.color,
        titleColor: Asset.accentColor.color,
        iconName: PetActivityType.walk.icon,
        title: L10n.OnboardingCare.Card.Walks.title.uppercased(with: Locale.current)
    )
    private lazy var groomingTile = OnboardingFeatureTileView(
        backgroundColor: Asset.petPurpleAction.color,
        iconBackgroundColor: Asset.lightPurple.color,
        iconTintColor: Asset.purpleAccent.color,
        titleColor: Asset.purpleAccent.color,
        iconName: PetActivityType.grooming.icon,
        title: L10n.OnboardingCare.Card.Grooming.title.uppercased(with: Locale.current)
    )
    private lazy var vetTile = OnboardingFeatureTileView(
        backgroundColor: Asset.petPinkAction.color,
        iconBackgroundColor: Asset.lightPink.color,
        iconTintColor: Asset.pinkAccent.color,
        titleColor: Asset.pinkAccent.color,
        iconName: PetActivityType.vet.icon,
        title: L10n.OnboardingCare.Card.Vet.title.uppercased(with: Locale.current)
    )
    private lazy var analyticsTile = OnboardingFeatureTileView(
        backgroundColor: Asset.petPurpleAction.color,
        iconBackgroundColor: Asset.lightPurple.color,
        iconTintColor: Asset.purpleAccent.color,
        titleColor: Asset.purpleAccent.color,
        iconName: "chart.bar.fill",
        title: L10n.OnboardingCare.Card.Analytics.title.uppercased(with: Locale.current)
    )

    private lazy var topRow = HStack(
        spacing: 12,
        distribution: .fillEqually,
        arrangedSubviews: [walkTile, groomingTile]
    )
    private lazy var bottomRow = HStack(
        spacing: 12,
        distribution: .fillEqually,
        arrangedSubviews: [analyticsTile, vetTile]
    )
    private lazy var gridStack = VStack(
        spacing: 12,
        arrangedSubviews: [topRow, bottomRow]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        addSubview(gridStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: topAnchor),
            gridStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            walkTile.heightAnchor.constraint(equalToConstant: 112),
            groomingTile.heightAnchor.constraint(equalToConstant: 112),
            vetTile.heightAnchor.constraint(equalToConstant: 112),
            analyticsTile.heightAnchor.constraint(equalToConstant: 112)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
