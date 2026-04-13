//
//  MiniGameScoreboardView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameScoreboardView: UIView {
    private let background = BackgroundView(
        backgroundColor: UIColor.white.withAlphaComponent(0.5),
        cornerRadius: 24
    )
    private let scoreLabel = TextLabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        textColor: .black,
        textAlignment: .center
    )
    private let highScoreLabel = TextLabel(
        font: .systemFont(ofSize: 12, weight: .bold),
        textColor: Asset.primaryGreen.color,
        textAlignment: .center
    )

    private lazy var textStack = VStack(
        spacing: 4,
        alignment: .center,
        arrangedSubviews: [
            scoreLabel,
            highScoreLabel
        ]
    )
    private var displayedScore: Int?
    private var displayedBestScore: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupHierarchy()
        setupLayout()
    }

    func setData(score: Int, bestScore: Int) {
        scoreLabel.text = "Score: \(formatted(score))"
        highScoreLabel.text = "HIGH: \(bestScore)"

        animateScoreIfNeeded(score: score)
        animateBestScoreIfNeeded(bestScore: bestScore)

        displayedScore = score
        displayedBestScore = bestScore
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(textStack)
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            widthAnchor.constraint(greaterThanOrEqualToConstant: 148),
            heightAnchor.constraint(equalToConstant: 70),

            textStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 13),
            textStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 14),
            textStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -14),
            textStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -11)
        ])
    }

    private func formatted(_ score: Int) -> String {
        String(format: "%04d", score)
    }

    private func animateScoreIfNeeded(score: Int) {
        guard let displayedScore, score > displayedScore else { return }

        scoreLabel.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.14, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
            self.scoreLabel.alpha = 0.92
        } completion: { _ in
            UIView.animate(
                withDuration: 0.18,
                delay: 0,
                usingSpringWithDamping: 0.62,
                initialSpringVelocity: 0.2,
                options: [.beginFromCurrentState, .curveEaseInOut]
            ) {
                self.scoreLabel.transform = .identity
                self.scoreLabel.alpha = 1
            }
        }
    }

    private func animateBestScoreIfNeeded(bestScore: Int) {
        guard let displayedBestScore, bestScore > displayedBestScore else { return }

        highScoreLabel.layer.removeAllAnimations()
        let initialColor = Asset.primaryGreen.color
        UIView.animate(withDuration: 0.18, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
            self.highScoreLabel.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.highScoreLabel.textColor = Asset.accentColor.color
            self.highScoreLabel.alpha = 1
        } completion: { _ in
            UIView.animate(
                withDuration: 0.32,
                delay: 0,
                usingSpringWithDamping: 0.74,
                initialSpringVelocity: 0.15,
                options: [.beginFromCurrentState, .curveEaseInOut]
            ) {
                self.highScoreLabel.transform = .identity
                self.highScoreLabel.textColor = initialColor
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
