//
//  ActivitiesHistoryView.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import UIKit

final class ActivitiesHistoryView: UIView {
    private let loader = UIActivityIndicatorView()
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = ActivitiesHistorySection(rawValue: sectionIndex) else { return nil }
            switch section {
            case .activities:
                return createActivitiesSection()
            }
        }
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
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
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        loader.hidesWhenStopped = true
        loader.style = .medium
    }
    
    func setupCollection(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate
    ) {
        collection.dataSource = dataSource
        collection.delegate = delegate
    }
    
    func registerCells() {
        collection
            .register(
                PetAnalyticsHistoryCell.self,
                forCellWithReuseIdentifier: PetAnalyticsHistoryCell.identifier
            )
    }
    
    func reloadData() {
        collection.reloadData()
    }
    
    func setLoader(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        
        loader.isHidden = !isLoading
        collection.isHidden = isLoading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivitiesHistoryView {
    private static func createActivitiesSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(76)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(76)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }
}
