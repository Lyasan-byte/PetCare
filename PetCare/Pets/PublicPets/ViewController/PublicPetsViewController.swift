//
//  PublicPetsViewController.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit
import Combine

final class PublicPetsViewController: UIViewController {
    private let content = PublicPetsView()
    private let publicPetsViewModel: any PublicPetsViewModeling
    private let imageLoader: ImageLoader
    
    private var bag = Set<AnyCancellable>()
    
    init(publicPetsViewModel: any PublicPetsViewModeling, imageLoader: ImageLoader) {
        self.publicPetsViewModel = publicPetsViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupCollection()
        bindViewModel()
        
        render(publicPetsViewModel.state)
        publicPetsViewModel.trigger(.onDidLoad)
    }
    
    private func setupCollection() {
        content.setupCollection(dataSource: self, delegate: self)
        content.registerCells()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(content)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: view.topAnchor),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        publicPetsViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.publicPetsViewModel.state)
            }
            .store(in: &bag)
    }
    
    private func render(_ state: PublicPetsState) {
        content.reloadData()
        content.setLoader(state.isLoading)
        if let error = state.errorMessage {
            showError(error)
        }
    }
    
    private func showError(_ message: String) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PublicPetsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        PublicPetsSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = PublicPetsSection(rawValue: section) else {
            return 0
        }
        switch section {
        case .header:
            return 1
        case .pets:
            return publicPetsViewModel.state.pets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = PublicPetsSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {
        case .header:
            return collectionView.dequeueReusableCell(withReuseIdentifier: PublicPetsHeaderCollectionViewCell.identifier, for: indexPath)
        case .pets:
            let pet = publicPetsViewModel.state.pets[indexPath.row]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicPetCollectionViewCell.identifier, for: indexPath) as? PublicPetCollectionViewCell {
                cell.setData(pet: pet, imageLoader: imageLoader)
                return cell
            }
            return UICollectionViewCell()
        }
    }
}

extension PublicPetsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = PublicPetsSection(rawValue: indexPath.section) else {
            return
        }
        switch section {
        case .header:
            break
        case .pets:
            let pet = publicPetsViewModel.state.pets[indexPath.item]
            publicPetsViewModel.trigger(.onPetCardTap(pet))
        }
    }
}
