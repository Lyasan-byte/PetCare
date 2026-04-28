//
//  PetAnalyticsViewController.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Combine
import UIKit

final class PetAnalyticsViewController: UIViewController {
    private let petAnalyticsView = PetAnalyticsView()
    private let petAnalyticsViewModel: any PetAnalyticsViewModeling
    private let imageLoader: ImageLoader
    
    private var bag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<PetAnalyticsSection, PetAnalyticsItem>?
    
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
        setupCollectionLayout()
        setupDataSource()
        bindViewModel()
        
        render()
        petAnalyticsViewModel.trigger(.onDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupAppearance() {
        title = L10n.PetAnalytics.title
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
    
    private func setupCollectionLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self,
                  let dataSource = self.dataSource else { return nil }

            let sections = dataSource.snapshot().sectionIdentifiers
            guard sectionIndex < sections.count else {
                return nil
            }

            let section = sections[sectionIndex]
            return PetAnalyticsView.createSection(section)
        }

        petAnalyticsView.setCollectionViewLayout(layout)
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
            applyEmptySnapshot()
            petAnalyticsView.setLoading(true)
            petAnalyticsView.showEmptyState(false)
            
        case .error(let error):
            applyEmptySnapshot()
            petAnalyticsView.setLoading(false)
            petAnalyticsView.showEmptyState(false)
            showError(error)
            
        case .empty:
            applyEmptySnapshot()
            petAnalyticsView.setLoading(false)
            petAnalyticsView.showEmptyState(true)
            
        case .content(let content):
            petAnalyticsView.setLoading(false)
            petAnalyticsView.showEmptyState(false)
            applySnapshot(content)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
        present(alert, animated: true)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<PetAnalyticsSection, PetAnalyticsItem>(
            collectionView: petAnalyticsView.collection
        ) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            switch item {
            case .header(let headerData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsHeaderCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsHeaderCell {
                    cell.onChangePeriod = { [weak self] selectedIndex in
                        guard let period = PetAnalyticsPeriod(rawValue: selectedIndex) else { return }
                        self?.petAnalyticsViewModel.trigger(.onChangePeriod(period))
                    }
                    
                    cell.setData(header: headerData, imageLoader: imageLoader)
                    
                    return cell
                }
            case .walkChart(let walkChartData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsChartCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsChartCell {
                    cell.setData(barChartData: walkChartData, style: .distance)
                    return cell
                }
            case .goal(let goalData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsGoalCompetionCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsGoalCompetionCell {
                    cell.setData(goalCompletion: goalData)
                    return cell
                }
            case .costChart(let costData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsChartCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsChartCell {
                    cell.setData(barChartData: costData, color: Asset.petYellow.color, style: .money)
                    return cell
                }
            case .stats(let statsData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsStatsCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsStatsCell {
                    cell.setData(stats: statsData)
                    return cell
                }
            case .historyHeader:
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsHistoryHeaderCell.identifier,
                    for: indexPath) as? PetAnalyticsHistoryHeaderCell {
                    cell.onTapButton = { [weak self] in
                        self?.petAnalyticsViewModel.trigger(.onHistoryButtonTap)
                    }
                    return cell
                }
            case .history(let historyData):
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PetAnalyticsHistoryCell.identifier,
                    for: indexPath
                ) as? PetAnalyticsHistoryCell {
                    cell.setData(history: historyData)
                    return cell
                }
            }
            return UICollectionViewCell()
        }
    }
    
    private func applySnapshot(_ content: PetAnalyticsContent) {
        var snapshot = NSDiffableDataSourceSnapshot<PetAnalyticsSection, PetAnalyticsItem>()
        
        if let analyticsHeaderData = content.analyticsHeaderData {
            snapshot.appendSections([.header])
            snapshot.appendItems([.header(analyticsHeaderData)], toSection: .header)
        }
        
        if let walkChartData = content.walkChartData {
            snapshot.appendSections([.walkChart])
            snapshot.appendItems([.walkChart(walkChartData)], toSection: .walkChart)
        }
        
        if let goalCompletionData = content.goalCompletionData {
            snapshot.appendSections([.goal])
            snapshot.appendItems([.goal(goalCompletionData)], toSection: .goal)
        }
        
        if let costChartData = content.spendingsChartData {
            snapshot.appendSections([.costChart])
            snapshot.appendItems([.costChart(costChartData)], toSection: .costChart)
        }
        
        if !content.statsData.isEmpty {
            snapshot.appendSections([.stats])
            snapshot.appendItems(content.statsData.map(PetAnalyticsItem.stats), toSection: .stats)
        }
        
        if !content.historyData.isEmpty {
            snapshot.appendSections([.historyHeader])
            snapshot.appendItems([.historyHeader], toSection: .historyHeader)
            
            snapshot.appendSections([.history])
            snapshot.appendItems(content.historyData.map(PetAnalyticsItem.history), toSection: .history)
        }
        dataSource?.apply(snapshot)
    }
    
    private func applyEmptySnapshot() {
        let snapshot = NSDiffableDataSourceSnapshot<PetAnalyticsSection, PetAnalyticsItem>()
        dataSource?.apply(snapshot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
