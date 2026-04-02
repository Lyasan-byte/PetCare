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
        petsMainView.collectionView.dataSource = self
        petsMainView.collectionView.delegate = self
        
        petsMainView.collectionView.register(
            PetsMainTopCell.self,
            forCellWithReuseIdentifier: PetsMainTopCell.identifier
        )
        
        petsMainView.collectionView.register(
            PetCardCollectionCell.self,
            forCellWithReuseIdentifier: PetCardCollectionCell.identifier
        )
    }
    
    private func render(_ state: PetsMainState) {
        petsMainView.collectionView.reloadData()
        petsMainView.showEmptyStateView(state.isEmptyState)
        petsMainView.setLoading(state.isLoading)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetsMainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return petsMainViewModel.state.pets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetsMainTopCell.identifier,
                for: indexPath
            ) as? PetsMainTopCell {
                cell.configure(
                    tipText: petsMainViewModel.state.tipText,
                    onTipTap: { [weak self] in
                        self?.petsMainViewModel.trigger(.onTipTap)
                    },
                    onQuickActionTap: { action in
                        print(action)
                    }
                )
                return cell
            }
            return UICollectionViewCell()
        } else {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetCardCollectionCell.identifier,
                for: indexPath
            ) as? PetCardCollectionCell {
                let pet = petsMainViewModel.state.pets[indexPath.item]
                cell.setData(pet: pet, imageLoader: imageLoader)
                return cell
            }
            return UICollectionViewCell()  
        }
    }
}

extension PetsMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let pet = petsMainViewModel.state.pets[indexPath.item]
        petsMainViewModel.trigger(.onPetTap(pet))
    }
}
