//
//  PublicPetsView.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class PublicPetsView: UIView {
    private let loader = UIActivityIndicatorView()
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = PublicPetsSection(rawValue: sectionIndex) else {
                return nil
            }
            switch section {
            case .header:
                return createHeaderSection()
            case .pets:
                return createPetsSection()
            }
        }
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    func setLoader(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        collection.isHidden = isLoading
    }
    
    func setupCollection(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate
    ) {
        collection.dataSource = dataSource
        collection.delegate = delegate
    }
    
    func registerCells() {
        collection.register(PublicPetsHeaderCollectionViewCell.self, forCellWithReuseIdentifier: PublicPetsHeaderCollectionViewCell.identifier)
        collection.register(PublicPetCollectionViewCell.self, forCellWithReuseIdentifier: PublicPetCollectionViewCell.identifier)
    }
    
    func reloadData() {
        collection.reloadData()
    }
    
    private func setupHierarchy() {
        addSubview(collection)
        addSubview(loader)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        loader.hidesWhenStopped = true
        loader.style = .medium
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PublicPetsView {
    private static func createHeaderSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
        
    }
    
    private static func createPetsSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230)))
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }
}
