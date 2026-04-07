//
//  PublicPetsViewController.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit
import Combine

final class PublicPetsViewController: UIViewController {
    private let publicPetsView = PublicPetsView()
    private let publicPetsViewModel: any PublicPetsViewModeling
    private let imageLoader: ImageLoader
    
    private var bag = Set<AnyCancellable>()
    private var content: PublicPetsContent? {
        guard case .content(let content) = publicPetsViewModel.state else { return nil }
        return content
    }
    
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
        publicPetsView.setupCollection(dataSource: self, delegate: self)
        publicPetsView.registerCells()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(publicPetsView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            publicPetsView.topAnchor.constraint(equalTo: view.topAnchor),
            publicPetsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            publicPetsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            publicPetsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        switch state {
        case .loading:
            publicPetsView.setLoader(true)
        case .content(let content):
            publicPetsView.setLoader(false)
            publicPetsView.reloadData()
        case .error(let error):
            publicPetsView.setLoader(false)
            showError(error)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default) { [weak self] _ in
            self?.publicPetsViewModel.trigger(.onDismissAlert)
        })
        present(alert, animated: true)
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
            return content?.pets.count ?? 0
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
            if let content, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicPetCollectionViewCell.identifier, for: indexPath) as? PublicPetCollectionViewCell {
                let pet = content.pets[indexPath.row]
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
            if let content {
                let pet = content.pets[indexPath.item]
                publicPetsViewModel.trigger(.onPetCardTap(pet))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = PublicPetsSection(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .header:
             break
        case .pets:
            publicPetsViewModel.trigger(.onReachedItem(index: indexPath.row))
        }
    }
}
