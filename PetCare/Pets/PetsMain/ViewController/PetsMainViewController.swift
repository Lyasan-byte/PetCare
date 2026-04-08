//
//  PetsMainViewController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit
import Combine

final class PetsMainViewController: UIViewController {
    private let petsMainView = PetsMainView()
    private let petsMainViewModel: any PetsMainViewModeling
    private let imageLoader: ImageLoader
    private var bag = Set<AnyCancellable>()

    init(petsMainviewModel: PetsMainViewModel, imageLoader: ImageLoader) {
        self.petsMainViewModel = petsMainviewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupHierarchy()
        setupLayout()
        setupCollectionView()
        bindAction()
        bindViewModel()
        render(petsMainViewModel.state)

        petsMainViewModel.trigger(.viewDidLoad)
    }

    private func setupHierarchy() {
        view.addSubview(petsMainView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            petsMainView.topAnchor.constraint(equalTo: view.topAnchor),
            petsMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petsMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petsMainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        petsMainView.setupCollection(dataSource: self, delegate: self)
        petsMainView.registerCells()
    }

    private func render(_ state: PetsMainState) {
        petsMainView.setLoading(state.isLoading)

        if state.isLoading {
            return
        }

        petsMainView.showEmptyStateView(state.isEmptyState)
        petsMainView.reloadData()

        if let errorMessage = state.errorMessage {
            showError(errorMessage)
        }
    }

    private func bindAction() {
        petsMainView.onAddPetButtonTap = { [weak self] in
            self?.petsMainViewModel.trigger(.onAddPetTap)
        }
    }

    private func bindViewModel() {
        petsMainViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.petsMainViewModel.state)
            }
            .store(in: &bag)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default) { [weak self] _ in
            self?.petsMainViewModel.trigger(.onDismissAlert)
        })
        present(alert, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetsMainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        PetsMainSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = PetsMainSection(rawValue: section) else { return 0 }
        switch section {
        case .top:
            return 1
        case .pets:
            return petsMainViewModel.state.pets.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = PetsMainSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {
        case .top:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetsMainTopCell.identifier,
                for: indexPath) as? PetsMainTopCell {
                cell.configure(
                    tipText: petsMainViewModel.state.tipText,
                    onTipTap: { [weak self] in
                        self?.petsMainViewModel.trigger(.onTipTap)
                    },
                    onQuickActionTap: { [weak self] activity in
                        self?.petsMainViewModel.trigger(.onAddActivity(activity))
                    })
                return cell
            }
        case .pets:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetCardCollectionCell.identifier,
                for: indexPath
            ) as? PetCardCollectionCell {
                let pet = petsMainViewModel.state.pets[indexPath.item]
                cell.setData(pet: pet, imageLoader: imageLoader)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension PetsMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = PetsMainSection(rawValue: indexPath.section) else { return }
        switch section {
        case .top:
            break
        case .pets:
            let pet = petsMainViewModel.state.pets[indexPath.item]
            petsMainViewModel.trigger(.onPetTap(pet))
        }
    }
}
