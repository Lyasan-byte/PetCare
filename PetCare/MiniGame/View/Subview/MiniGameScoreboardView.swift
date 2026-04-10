//
//  MiniGameScoreboardView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameScoreboardView: UIView {
    private let background = BackgroundView(
        backgroundColor: UIColor.white.withAlphaComponent(0.82),
        cornerRadius: 18
    )
    private let scoreLabel = TextLabel(
        font: .systemFont(ofSize: 15, weight: .bold),
        textColor: .label,
        textAlignment: .left
    )
    private let highScoreLabel = TextLabel(
        font: .systemFont(ofSize: 12, weight: .bold),
        textColor: Asset.textGreen.color,
        textAlignment: .left
    )

    private lazy var textStack = VStack(
        spacing: 4,
        alignment: .leading,
        arrangedSubviews: [
            scoreLabel,
            highScoreLabel
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    func setData(score: Int, bestScore: Int) {
        scoreLabel.text = "Score: \(formatted(score))"
        highScoreLabel.text = "HIGH: \(bestScore)"
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(textStack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            textStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -12)
        ])
    }

    private func formatted(_ score: Int) -> String {
        String(format: "%04d", score)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
