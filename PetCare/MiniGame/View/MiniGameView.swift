//
//  MiniGameView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit

final class MiniGameView: UIView {
    var onGameFieldTap: (() -> Void)?
    var onRestartTap: (() -> Void)?
    var onGameScoreChanged: ((Int) -> Void)?
    var onGameEnded: ((Int) -> Void)?

    private let loader = UIActivityIndicatorView(style: .medium)
    private let scrollView = ScrollView()
    private let contentView = UIView()
    private let header = Header(
        icon: "gamecontroller.fill",
        text: NSLocalizedString("mini.game.screen.title", comment: "")
    )
    private let runnerSectionTitle = TextLabel(
        font: .systemFont(ofSize: 12, weight: .semibold),
        text: NSLocalizedString("mini.game.runner.select", comment: ""),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    private let emptyStateView = EmptyStateView(
        title: NSLocalizedString("mini.game.empty.title", comment: ""),
        subtitle: NSLocalizedString("mini.game.empty.subtitle", comment: ""),
        image: "pawprint.fill"
    )
    private let fieldView = MiniGameFieldView()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 94, height: 126)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()

    private lazy var runnersStack = VStack(
        spacing: 16,
        arrangedSubviews: [
            runnerSectionTitle,
            collectionView,
            emptyStateView
        ]
    )
    private lazy var contentStack = VStack(
        spacing: 16,
        arrangedSubviews: [
            header,
            runnersStack,
            fieldView
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
        bindActions()
    }

    func setupCollection(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate
    ) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }

    func registerCells() {
        collectionView.register(
            MiniGameRunnerCollectionViewCell.self,
            forCellWithReuseIdentifier: MiniGameRunnerCollectionViewCell.identifier
        )
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }

        scrollView.isHidden = isLoading
        loader.isHidden = !isLoading
    }

    func setData(content: MiniGameContent) {
        emptyStateView.isHidden = !content.isEmpty
        collectionView.isHidden = content.isEmpty
        fieldView.setData(content: content)
    }

    func startGame(with pet: Pet, imageLoader: ImageLoader) {
        fieldView.startGame(with: pet, imageLoader: imageLoader)
    }

    func stopGame() {
        fieldView.stopGame()
    }

    func jump() {
        fieldView.jump()
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(loader)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStack)
    }

    private func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            collectionView.heightAnchor.constraint(equalToConstant: 126),
            fieldView.heightAnchor.constraint(equalToConstant: 490),

            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        loader.hidesWhenStopped = true
        scrollView.alwaysBounceVertical = true
        emptyStateView.isHidden = true

        header.titleIcon.tintColor = Asset.accentColor.color
        header.screenTitle.textColor = Asset.accentColor.color
    }

    private func bindActions() {
        fieldView.onTap = { [weak self] in
            self?.onGameFieldTap?()
        }

        fieldView.onRestartTap = { [weak self] in
            self?.onRestartTap?()
        }

        fieldView.onScoreChanged = { [weak self] score in
            self?.onGameScoreChanged?(score)
        }

        fieldView.onGameEnded = { [weak self] score in
            self?.onGameEnded?(score)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
