//
//  MiniGameOverlayContainerView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13/04/26.
//

import UIKit

final class MiniGameOverlayContainerView: UIView {
    var onRestartTap: (() -> Void)?

    private let scoreView = MiniGameScoreboardView()
    private let idleView = MiniGameIdleOverlayView()
    private let gameOverDimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        view.isHidden = true
        return view
    }()
    private let gameOverView = MiniGameGameOverView()

    private var lastRenderedStage: MiniGameStage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupHierarchy()
        setupLayout()
        bindActions()
    }

    func render(content: MiniGameContent, isGameVisible: Bool) {
        let previousStage = lastRenderedStage

        scoreView.setData(score: content.currentScore, bestScore: content.bestScore)
        idleView.setPetSelected(content.selectedPet != nil)

        switch content.stage {
        case .idle:
            idleView.isHidden = false
            gameOverDimView.isHidden = true
            gameOverView.isHidden = true
            gameOverView.alpha = 1
            gameOverView.transform = .identity
            gameOverDimView.alpha = 1
        case .started:
            idleView.isHidden = true
            gameOverDimView.isHidden = true
            gameOverView.isHidden = true
            gameOverView.alpha = 1
            gameOverView.transform = .identity
            gameOverDimView.alpha = 1
        case .finished:
            idleView.isHidden = true
            gameOverDimView.isHidden = false
            gameOverView.isHidden = false
            gameOverView.setData(score: content.lastRunScore, bestScore: content.bestScore)

            if previousStage != .finished {
                animateGameOverPresentation()
            }
        }

        lastRenderedStage = content.stage
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    private func setupHierarchy() {
        [
            scoreView,
            idleView,
            gameOverDimView,
            gameOverView
        ].forEach(addSubview)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            scoreView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),

            idleView.topAnchor.constraint(equalTo: topAnchor),
            idleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            idleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            idleView.bottomAnchor.constraint(equalTo: bottomAnchor),

            gameOverDimView.topAnchor.constraint(equalTo: topAnchor),
            gameOverDimView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gameOverDimView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gameOverDimView.bottomAnchor.constraint(equalTo: bottomAnchor),

            gameOverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            gameOverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            gameOverView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func bindActions() {
        gameOverView.restartButton.onTap = { [weak self] in
            self?.onRestartTap?()
        }
    }

    private func animateGameOverPresentation() {
        gameOverDimView.alpha = 0
        gameOverView.alpha = 0
        gameOverView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)

        UIView.animate(withDuration: 0.18, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
            self.gameOverDimView.alpha = 1
        }

        UIView.animate(
            withDuration: 0.32,
            delay: 0.04,
            usingSpringWithDamping: 0.78,
            initialSpringVelocity: 0.15,
            options: [.beginFromCurrentState, .curveEaseInOut]
        ) {
            self.gameOverView.alpha = 1
            self.gameOverView.transform = .identity
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
