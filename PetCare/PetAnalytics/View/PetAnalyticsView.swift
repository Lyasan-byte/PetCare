//
//  PetAnalyticsView.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsView: UIView {
    private let loader = UIActivityIndicatorView()
    private let emptyStateView = EmptyStateView(title: "No Activities", subtitle: "", image: "text.page.slash")
    let collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = PetAnalyticsSection(rawValue: sectionIndex) else {
                return nil
            }
            return createSection(section)
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
            
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.isHidden = true
        loader.hidesWhenStopped = true
        loader.style = .medium
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
    private static func createSection(_ section: PetAnalyticsSection) -> NSCollectionLayoutSection {
        switch section {
        case .header:
            return createHeaderSection()
        case .walkChart:
            return createWalkChartSection()
        case .goal:
            return createGoalSection()
        case .costChart:
            return createCostChartSection()
        case .stats:
            return createStatsSection()
        case .historyHeader:
            return createHistoryHeaderSection()
        case .history:
            return createActivityHistorySection()
        }
    }
    
    private static func createHeaderSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createWalkChartSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createGoalSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createCostChartSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createStatsSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createHistoryHeaderSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(30)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(30)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createActivityHistorySection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
