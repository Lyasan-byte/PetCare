//
//  PetAnalyticsView.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsView: UIView {
    private let loader = UIActivityIndicatorView()
    private let emptyStateView = EmptyStateView(
        title: L10n.PetAnalytics.EmptyState.title,
        subtitle: L10n.PetAnalytics.EmptyState.subtitle,
        image: {
            if #available(iOS 17.0, *) { return "dog.fill" }
            return "figure.walk"
        }()
    )
    let collection: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
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
        addSubview(emptyStateView)
        addSubview(loader)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.isHidden = true
        loader.hidesWhenStopped = true
        loader.style = .medium
    }
    
    func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool = false) {
        collection.setCollectionViewLayout(layout, animated: animated)
    }
    
    func registerCells() {
        collection
            .register(
                PetAnalyticsHeaderCell.self,
                forCellWithReuseIdentifier: PetAnalyticsHeaderCell.identifier
            )
        collection
            .register(
                PetAnalyticsChartCell.self,
                forCellWithReuseIdentifier: PetAnalyticsChartCell.identifier
            )
        collection
            .register(
                PetAnalyticsGoalCompetionCell.self,
                forCellWithReuseIdentifier: PetAnalyticsGoalCompetionCell.identifier
            )
        collection
            .register(
                PetAnalyticsStatsCell.self,
                forCellWithReuseIdentifier: PetAnalyticsStatsCell.identifier
            )
        
        collection
            .register(
                PetAnalyticsHistoryHeaderCell.self,
                forCellWithReuseIdentifier: PetAnalyticsHistoryHeaderCell.identifier
            )
        collection
            .register(
                PetAnalyticsHistoryCell.self,
                forCellWithReuseIdentifier: PetAnalyticsHistoryCell.identifier
            )
    }
    
    func showEmptyState(_ isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
        collection.isHidden = isEmpty
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        loader.isHidden = !isLoading
        collection.isHidden = isLoading
        emptyStateView.isHidden = isLoading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetAnalyticsView {
    static func createSection(_ section: PetAnalyticsSection) -> NSCollectionLayoutSection {
        switch section {
        case .header:
            return makeSection(height: 120, topInset: 5)
        case .walkChart:
            return makeSection(height: 240, topInset: 20)
        case .goal:
            return makeSection(height: 250, topInset: 16)
        case .costChart:
            return makeSection(height: 240, topInset: 16)
        case .stats:
            return makeSection(height: 76, topInset: 16, interGroupSpacing: 16)
        case .historyHeader:
            return makeSection(height: 30, topInset: 16)
        case .history:
            return makeSection(height: 76, topInset: 16, interGroupSpacing: 16)
        }
    }

    private static func makeSection(
        height: CGFloat,
        topInset: CGFloat,
        interGroupSpacing: CGFloat = 0
    ) -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )

        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: size,
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: topInset, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = interGroupSpacing
        return section
    }
}
