//
//  PublicPetGameScoreView.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import UIKit

final class PublicPetGameScoreView: UIView {
    private let background = BackgroundView(backgroundColor: Asset.lightPink.color)
    private let spacer = UIView()
    private let icon = CircleIconView(
        symbolName: "gamecontroller.fill",
        iconColor: Asset.pinkAccentStatus.color,
        circleColor: Asset.petPink.color.withAlphaComponent(0.8),
        circleSize: 40,
        iconSize: 16
    )
    private let gameScoreTitle = TextLabel(
        font: .systemFont(
            ofSize: 14,
            weight: .regular
        ),
        text: L10n.Pets.Public.GameScore.title,
        textColor: Asset.pinkAccent.color,
        textAlignment: .left
    )
    private let gameScore = TextLabel(
        font: .systemFont(
            ofSize: 22,
            weight: .semibold
        ),
        textColor: Asset.pinkAccent.color,
        textAlignment: .left
    )

    private let medalImage: ImageView = {
        let imageView = ImageView(tintColor: Asset.pinkAccent.color)
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        imageView.image = UIImage(systemName: "medal", withConfiguration: config)
        return imageView
    }()

    private lazy var textStack = VStack(
        spacing: 10,
        arrangedSubviews: [
            gameScoreTitle,
            gameScore
        ]
    )
    private lazy var contentStack = HStack(
        spacing: 16,
        alignment: .center,
        arrangedSubviews: [
            icon,
            textStack,
            spacer,
            medalImage
        ]
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
        addSubview(background)
        background.addSubview(contentStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }

    func setData(gameScore: Int) {
        self.gameScore.text = PetScoreFormatter.string(for: gameScore)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
