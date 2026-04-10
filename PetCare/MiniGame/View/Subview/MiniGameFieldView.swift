//
//  MiniGameFieldView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameFieldView: UIView {
    var onTap: (() -> Void)?
    var onRestartTap: (() -> Void)?

    private let backgroundView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let bottomGlowView = UIView()
    private let groundLineView = UIView()
    private let gameOverDimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        view.isHidden = true
        return view
    }()
    private let scoreView = MiniGameScoreboardView()
    private let gameOverView = MiniGameGameOverView()

    private let tapCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 66
        view.layer.borderWidth = 2
        view.layer.borderColor = Asset.accentColor.color.withAlphaComponent(0.3).cgColor
        view.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        return view
    }()

    private let tapIcon: ImageView = {
        let imageView = ImageView(tintColor: Asset.accentColor.color)
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        imageView.image = UIImage(systemName: "hand.tap", withConfiguration: config)
        return imageView
    }()

    private let tapTitleLabel = TextLabel(
        font: .systemFont(ofSize: 18, weight: .semibold),
        text: NSLocalizedString("mini.game.field.tap_to_jump", comment: ""),
        textColor: .gray
    )
    private let tapSubtitleLabel = TextLabel(
        font: .systemFont(ofSize: 14, weight: .medium),
        textColor: .gray
    )

    private let runnerPreview: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = Asset.accentColor.color.withAlphaComponent(0.4).cgColor
        return imageView
    }()

    private let runnerNameLabel = TextLabel(
        font: .systemFont(ofSize: 24, weight: .bold),
        textColor: Asset.accentColor.color
    )
    private let runningTitleLabel = TextLabel(
        font: .systemFont(ofSize: 16, weight: .semibold),
        text: NSLocalizedString("mini.game.field.running", comment: ""),
        textColor: .label
    )
    private let runningSubtitleLabel = TextLabel(
        font: .systemFont(ofSize: 14, weight: .medium),
        text: NSLocalizedString("mini.game.field.preview_hint", comment: ""),
        textColor: .gray
    )

    private lazy var idleStack = VStack(
        spacing: 14,
        arrangedSubviews: [
            tapCircleView,
            tapTitleLabel,
            tapSubtitleLabel
        ]
    )

    private lazy var runningStack = VStack(
        spacing: 12,
        arrangedSubviews: [
            runnerPreview,
            runnerNameLabel,
            runningTitleLabel,
            runningSubtitleLabel
        ]
    )

    private lazy var decorationViews: [ImageView] = (0..<3).map { _ in
        let imageView = ImageView(
            contentMode: .scaleAspectFit,
            tintColor: Asset.lightGreen.color.withAlphaComponent(0.3)
        )
        let config = UIImage.SymbolConfiguration(pointSize: 42, weight: .regular)
        imageView.image = UIImage(systemName: "tree.fill", withConfiguration: config)
        return imageView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
        bindActions()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundView.bounds
    }

    func setData(content: MiniGameContent, imageLoader: ImageLoader) {
        let selectedPet = content.selectedPet

        scoreView.setData(score: content.currentScore, bestScore: content.bestScore)
        tapSubtitleLabel.text = selectedPet == nil
            ? NSLocalizedString("mini.game.field.no_pet", comment: "")
            : nil
        tapSubtitleLabel.isHidden = selectedPet != nil

        if let selectedPet {
            runnerPreview.setImage(urlString: selectedPet.photoUrl, imageLoader: imageLoader)
            runnerNameLabel.text = selectedPet.name
        } else {
            runnerPreview.image = Asset.defaultProfilePhoto.image
            runnerNameLabel.text = ""
        }

        switch content.stage {
        case .idle:
            idleStack.isHidden = false
            runningStack.isHidden = true
            gameOverDimView.isHidden = true
            gameOverView.isHidden = true
        case .started:
            idleStack.isHidden = true
            runningStack.isHidden = false
            gameOverDimView.isHidden = true
            gameOverView.isHidden = true
        case .finished:
            idleStack.isHidden = true
            runningStack.isHidden = true
            gameOverDimView.isHidden = false
            gameOverView.isHidden = false
            gameOverView.setData(score: content.lastRunScore, bestScore: content.bestScore)
        }

        backgroundView.alpha = content.isEmpty ? 0.72 : 1
    }

    private func setupHierarchy() {
        addSubview(backgroundView)

        [
            bottomGlowView,
            groundLineView,
            scoreView,
            idleStack,
            runningStack,
            gameOverDimView,
            gameOverView
        ].forEach(backgroundView.addSubview)

        decorationViews.forEach(backgroundView.addSubview)
        tapCircleView.addSubview(tapIcon)
    }

    private func setupLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        bottomGlowView.translatesAutoresizingMaskIntoConstraints = false
        groundLineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scoreView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 18),
            scoreView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -18),

            tapCircleView.widthAnchor.constraint(equalToConstant: 132),
            tapCircleView.heightAnchor.constraint(equalToConstant: 132),
            tapIcon.centerXAnchor.constraint(equalTo: tapCircleView.centerXAnchor),
            tapIcon.centerYAnchor.constraint(equalTo: tapCircleView.centerYAnchor),
            tapIcon.widthAnchor.constraint(equalToConstant: 42),
            tapIcon.heightAnchor.constraint(equalToConstant: 42),

            idleStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            idleStack.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -10),
            idleStack.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundView.leadingAnchor, constant: 24),
            idleStack.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.trailingAnchor, constant: -24),

            runnerPreview.widthAnchor.constraint(equalToConstant: 88),
            runnerPreview.heightAnchor.constraint(equalToConstant: 88),
            runningStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            runningStack.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -8),
            runningStack.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundView.leadingAnchor, constant: 24),
            runningStack.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.trailingAnchor, constant: -24),

            gameOverDimView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            gameOverDimView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            gameOverDimView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            gameOverDimView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),

            gameOverView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            gameOverView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),
            gameOverView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),

            bottomGlowView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            bottomGlowView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            bottomGlowView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            bottomGlowView.heightAnchor.constraint(equalToConstant: 56),

            groundLineView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            groundLineView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            groundLineView.bottomAnchor.constraint(equalTo: bottomGlowView.topAnchor),
            groundLineView.heightAnchor.constraint(equalToConstant: 3)
        ])

        let leftTree = decorationViews[0]
        let centerTree = decorationViews[1]
        let rightTree = decorationViews[2]

        NSLayoutConstraint.activate([
            leftTree.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            leftTree.bottomAnchor.constraint(equalTo: groundLineView.topAnchor, constant: -36),
            leftTree.widthAnchor.constraint(equalToConstant: 40),
            leftTree.heightAnchor.constraint(equalToConstant: 40),

            centerTree.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: -24),
            centerTree.bottomAnchor.constraint(equalTo: groundLineView.topAnchor, constant: -28),
            centerTree.widthAnchor.constraint(equalToConstant: 64),
            centerTree.heightAnchor.constraint(equalToConstant: 64),

            rightTree.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -28),
            rightTree.bottomAnchor.constraint(equalTo: groundLineView.topAnchor, constant: -34),
            rightTree.widthAnchor.constraint(equalToConstant: 44),
            rightTree.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 38
        backgroundView.clipsToBounds = true

        gradientLayer.colors = [
            Asset.lightGreen.color.withAlphaComponent(0.16).cgColor,
            UIColor.white.cgColor,
            Asset.lightGreen.color.withAlphaComponent(0.24).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)

        bottomGlowView.backgroundColor = Asset.petGreen.color.withAlphaComponent(0.14)
        groundLineView.backgroundColor = Asset.primaryGreen.color.withAlphaComponent(0.35)

        runningStack.isHidden = true
        gameOverView.isHidden = true
    }

    private func bindActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapField))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true

        gameOverView.restartButton.onTap = { [weak self] in
            self?.onRestartTap?()
        }
    }

    @objc private func didTapField() {
        onTap?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
