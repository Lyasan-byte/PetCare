//
//  MiniGameGameOverView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameGameOverView: UIView {
    let restartButton = PrimaryButton(
        title: NSLocalizedString("mini.game.field.restart", comment: ""),
        backgroundColor: Asset.primaryGreen.color,
        textColor: Asset.textGreen.color
    )

    private let background = BackgroundView(
        backgroundColor: Asset.authCardViewColor.color.withAlphaComponent(0.95),
        cornerRadius: 28
    )
    private let titleLabel = TextLabel(
        font: .systemFont(ofSize: 24, weight: .bold),
        text: NSLocalizedString("mini.game.field.game_over", comment: ""),
        textColor: .label
    )
    private let scoreLabel = TextLabel(
        font: .systemFont(ofSize: 18, weight: .semibold),
        textColor: Asset.accentColor.color
    )
    private let bestScoreLabel = TextLabel(
        font: .systemFont(ofSize: 15, weight: .medium),
        textColor: Asset.petGray.color
    )

    private lazy var stack = VStack(
        spacing: 12,
        arrangedSubviews: [
            titleLabel,
            scoreLabel,
            bestScoreLabel,
            restartButton
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func setData(score: Int, bestScore: Int) {
        scoreLabel.text = "\(NSLocalizedString("mini.game.field.last_score", comment: "")): \(formatted(score))"
        bestScoreLabel.text = "\(NSLocalizedString("mini.game.field.best_score", comment: "")): \(bestScore)"
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(stack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            heightAnchor.constraint(greaterThanOrEqualToConstant: 220),

            stack.topAnchor.constraint(equalTo: background.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        background.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 0, height: 18)
        background.layer.shadowRadius = 28
        background.clipsToBounds = false
    }

    private func formatted(_ score: Int) -> String {
        String(format: "%04d", score)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
