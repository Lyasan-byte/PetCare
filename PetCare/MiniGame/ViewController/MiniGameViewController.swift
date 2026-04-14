//
//  MiniGameViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import UIKit
import Combine

final class MiniGameViewController: UIViewController {
    private let miniGameView = MiniGameView()
    private let miniGameViewModel: any MiniGameViewModeling
    private let imageLoader: ImageLoader

    private var bag = Set<AnyCancellable>()
    private var lastRenderedRunnerKeys: [String] = []
    private var lastRenderedSelectedPetKey: String?
    private var content: MiniGameContent? {
        guard case .content(let content) = miniGameViewModel.state else { return nil }
        return content
    }

    init(miniGameViewModel: any MiniGameViewModeling, imageLoader: ImageLoader) {
        self.miniGameViewModel = miniGameViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupCollection()
        bindActions()
        bindViewModel()

        render(miniGameViewModel.state)
        miniGameViewModel.trigger(.onDidLoad)
    }

    private func setupAppearance() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(miniGameView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            miniGameView.topAnchor.constraint(equalTo: view.topAnchor),
            miniGameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            miniGameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            miniGameView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCollection() {
        miniGameView.setupCollection(dataSource: self, delegate: self)
        miniGameView.registerCells()
    }

    private func bindActions() {
        miniGameView.onGameFieldTap = { [weak self] in
            guard let self else { return }
            guard let content = self.content else { return }

            switch content.stage {
            case .idle:
                self.miniGameViewModel.trigger(.onGameFieldTap)
            case .finished:
                return
            case .started:
                self.miniGameView.jump()
            }
        }

        miniGameView.onRestartTap = { [weak self] in
            self?.miniGameViewModel.trigger(.onRestartTap)
        }

        miniGameView.onGameScoreChanged = { [weak self] score in
            self?.miniGameViewModel.trigger(.onGameScoreUpdated(score))
        }

        miniGameView.onGameEnded = { [weak self] score in
            self?.miniGameViewModel.trigger(.onGameEnded(score))
        }
    }

    private func bindViewModel() {
        miniGameViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.miniGameViewModel.state)
            }
            .store(in: &bag)
    }

    private func render(_ state: MiniGameState) {
        switch state {
        case .loading:
            miniGameView.setLoading(true)
        case .content(let content):
            miniGameView.setLoading(false)
            miniGameView.setData(content: content)
            reloadRunnerSelectionIfNeeded(content)

            switch content.stage {
            case .idle:
                miniGameView.stopGame()
            case .started:
                if let selectedPet = content.selectedPet {
                    miniGameView.startGame(with: selectedPet, imageLoader: imageLoader)
                }
            case .finished:
                break
            }
        case .error(let error):
            miniGameView.setLoading(false)
            showError(error)
        }
    }

    private func reloadRunnerSelectionIfNeeded(_ content: MiniGameContent) {
        let runnerKeys = content.pets.map(\.miniGameRunnerKey)
        guard runnerKeys != lastRenderedRunnerKeys || content.selectedPetKey != lastRenderedSelectedPetKey else {
            return
        }

        lastRenderedRunnerKeys = runnerKeys
        lastRenderedSelectedPetKey = content.selectedPetKey
        miniGameView.reloadData()
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default) { [weak self] _ in
            self?.miniGameViewModel.trigger(.onDismissAlert)
        })
        present(alert, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MiniGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content?.pets.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let content,
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MiniGameRunnerCollectionViewCell.identifier,
                for: indexPath
            ) as? MiniGameRunnerCollectionViewCell else {
            return UICollectionViewCell()
        }

        let pet = content.pets[indexPath.item]
        let isSelected = pet.miniGameRunnerKey == content.selectedPet?.miniGameRunnerKey
        cell.setData(pet: pet, isSelected: isSelected, imageLoader: imageLoader)
        return cell
    }
}

extension MiniGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pet = content?.pets[indexPath.item] else { return }
        miniGameViewModel.trigger(.onPetSelected(pet))
    }
}
