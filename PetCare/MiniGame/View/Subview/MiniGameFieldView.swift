//
//  MiniGameFieldView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit
import SpriteKit
import Combine

final class MiniGameFieldView: UIView {
    var onTap: (() -> Void)?
    var onRestartTap: (() -> Void)?
    var onScoreChanged: ((Int) -> Void)?
    var onGameEnded: ((Int) -> Void)?

    private let backgroundView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let decorView = MiniGameBackgroundDecorView()
    private let gameView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    private let overlayView = MiniGameOverlayContainerView()

    private var imageLoadCancellable: AnyCancellable?
    private var currentRunnerKey: String?
    private var currentScene: MiniGameScene?
    private var hasPendingJump = false

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

    func setData(content: MiniGameContent) {
        gameView.isHidden = switch content.stage {
        case .idle: currentScene == nil
        case .started, .finished: false
        }

        overlayView.render(content: content, isGameVisible: currentScene != nil)
        backgroundView.alpha = content.isEmpty ? 0.72 : 1
    }

    func startGame(with pet: Pet, imageLoader: ImageLoader) {
        guard currentRunnerKey != pet.miniGameRunnerKey || currentScene == nil else { return }

        imageLoadCancellable?.cancel()
        currentRunnerKey = pet.miniGameRunnerKey
        hasPendingJump = false

        guard let photoUrl = pet.photoUrl, let url = URL(string: photoUrl) else {
            presentScene(with: Asset.defaultProfilePhoto.image)
            return
        }

        imageLoadCancellable = imageLoader.loadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure = completion {
                    self.presentScene(with: Asset.defaultProfilePhoto.image)
                }
            } receiveValue: { [weak self] image in
                self?.presentScene(with: image)
            }
    }

    func stopGame() {
        imageLoadCancellable?.cancel()
        currentScene?.stop()
        currentScene = nil
        currentRunnerKey = nil
        hasPendingJump = false
        gameView.presentScene(nil)
        gameView.isHidden = true
    }

    func jump() {
        guard let currentScene else {
            hasPendingJump = true
            return
        }

        currentScene.jump()
    }

    private func presentScene(with image: UIImage) {
        layoutIfNeeded()

        let sceneSize = CGSize(
            width: max(gameView.bounds.width, 1),
            height: max(gameView.bounds.height, 1)
        )
        let scene = MiniGameScene(size: sceneSize, runnerImage: image)
        scene.output = self
        currentScene = scene
        gameView.isHidden = false
        gameView.presentScene(scene)

        if hasPendingJump {
            hasPendingJump = false
            DispatchQueue.main.async { [weak self] in
                self?.currentScene?.jump()
            }
        }
    }

    private func setupHierarchy() {
        addSubview(backgroundView)

        [decorView, gameView, overlayView].forEach(backgroundView.addSubview)
    }

    private func setupLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            decorView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            decorView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            decorView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            decorView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),

            gameView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            gameView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            gameView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            gameView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),

            overlayView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
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
    }

    private func bindActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapField))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true

        overlayView.onRestartTap = { [weak self] in
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

extension MiniGameFieldView: MiniGameSceneOutput {
    func miniGameSceneDidUpdateScore(_ score: Int) {
        onScoreChanged?(score)
    }

    func miniGameSceneDidEndGame(score: Int) {
        onGameEnded?(score)
    }
}
