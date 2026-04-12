//
//  PetAnalyticsViewController.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Combine
import UIKit

enum Item: Hashable, Sendable {
    case header
    case walkChart
    case goal
    case costChart
    case stats
    case historyHeader
    case history
}

final class PetAnalyticsViewController: UIViewController {
    private let petAnalyticsView = PetAnalyticsView()
    private let petAnalyticsViewModel: any PetAnalyticsViewModeling
    private let imageLoader: ImageLoader
    
    private var bag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<PetAnalyticsSection, Item>?
    
    init(petAnalyticsViewModel: any PetAnalyticsViewModeling, imageLoader: ImageLoader) {
        self.petAnalyticsViewModel = petAnalyticsViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupHierarchy()
        setupLayout()
        setupCollection()
        setupDataSource()
        bindViewModel()
        
        render()
        petAnalyticsViewModel.trigger(.onDidLoad)
    }
    
    private func setupAppearance() {
        title = "Analytics"
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(petAnalyticsView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petAnalyticsView.topAnchor.constraint(equalTo: view.topAnchor),
            petAnalyticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petAnalyticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petAnalyticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollection() {
        petAnalyticsView.registerCells()
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<PetAnalyticsSection, Item>(
            collectionView: petAnalyticsView.collection
        ) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            switch item {
            case .header(let headerData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsHeaderCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsHeaderCell {
                    cell
                        .setData(
                            header: headerData,
                            imageLoader: imageLoader
                        )
                    return cell
                }
            }
            
            return UICollectionViewCell()
        }
    }
    
    private func applySnapshot(_ content: PetAnalyticsContent) {
        var snapshot = NSDiffableDataSourceSnapshot<PetAnalyticsSection, Item>()
        
        snapshot.appendSections([PetAnalyticsSection.header])
        snapshot.appendItems([PetAnalyticsItem.header(content.analyticsHeaderData)], toSection: PetAnalyticsSection.header)
        
        dataSource?.apply(snapshot)
    }
    
    private func bindViewModel() {
        petAnalyticsViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.render()
            }
            .store(in: &bag)
    }
    
    private func render() {
        switch petAnalyticsViewModel.state {
        case .loading:
            petAnalyticsView.setLoading(true)
        case .error(let error):
            showError(error)
        case .empty:
            petAnalyticsView.showEmptyState(true)
        case .content(let content):
            applySnapshot(content)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
        present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
