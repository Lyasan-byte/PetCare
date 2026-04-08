//
//  UserProfileStatsView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit

final class UserProfileStatsView: UIView {
    private let petsCardView = UserProfileStatCardView()
    private let bestScoreCardView = UserProfileStatCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    func configure(content: UserProfileContent) {
        petsCardView.configure(
            value: content.petsCountText,
            title: NSLocalizedString("user.profile.pets.count", comment: ""),
            backgroundColor: Asset.petPinkAction.color.withAlphaComponent(0.4),
            textColor: Asset.darkPink.color
        )

        bestScoreCardView.configure(
            value: content.bestScoreText,
            title: NSLocalizedString("user.profile.best.score", comment: ""),
            backgroundColor: Asset.petPinkAction.color.withAlphaComponent(0.7),
            textColor: Asset.darkPink.color
        )
    }

    private func setupHierarchy() {
        addSubview(petsCardView)
        addSubview(bestScoreCardView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            petsCardView.topAnchor.constraint(equalTo: topAnchor),
            petsCardView.leadingAnchor.constraint(equalTo: leadingAnchor),

            bestScoreCardView.topAnchor.constraint(equalTo: topAnchor),
            bestScoreCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bestScoreCardView.leadingAnchor.constraint(equalTo: petsCardView.trailingAnchor, constant: 16),
            bestScoreCardView.widthAnchor.constraint(equalTo: petsCardView.widthAnchor),

            petsCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bestScoreCardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
