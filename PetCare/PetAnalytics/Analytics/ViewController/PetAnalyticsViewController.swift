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
        bindLanguageChanges()
        
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
            guard
                let self,
                let dataSource = self.dataSource
            else {
                return nil
            }

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

    private func bindLanguageChanges() {
        NotificationCenter.default.publisher(for: .settingsLanguageDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadLocalizedView()
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

            return self.makeCell(
                in: collectionView,
                at: indexPath,
                item: item
            )
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

    private func reloadLocalizedView() {
        title = L10n.PetAnalytics.title
        petAnalyticsViewModel.trigger(.onLanguageDidChange)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PetAnalyticsViewController {
    func makeCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        item: PetAnalyticsItem
    ) -> UICollectionViewCell {
        switch item {
        case .header(let headerData):
            return makeHeaderCell(in: collectionView, at: indexPath, headerData: headerData)
        case .walkChart(let walkChartData):
            return makeChartCell(in: collectionView, at: indexPath, data: walkChartData, style: .distance)
        case .goal(let goalData):
            return makeGoalCell(in: collectionView, at: indexPath, data: goalData)
        case .costChart(let costData):
            return makeChartCell(
                in: collectionView,
                at: indexPath,
                data: costData,
                color: Asset.petYellow.color,
                style: .money
            )
        case .stats(let statsData):
            return makeStatsCell(in: collectionView, at: indexPath, data: statsData)
        case .historyHeader:
            return makeHistoryHeaderCell(in: collectionView, at: indexPath)
        case .history(let historyData):
            return makeHistoryCell(in: collectionView, at: indexPath, data: historyData)
        }
    }

    func makeHeaderCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        headerData: PetAnalyticsHeaderData
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PetAnalyticsHeaderCell.identifier,
            for: indexPath
        ) as? PetAnalyticsHeaderCell else {
            return UICollectionViewCell()
        }

        cell.onChangePeriod = { [weak self] selectedIndex in
            guard let period = PetAnalyticsPeriod(rawValue: selectedIndex) else { return }
            self?.petAnalyticsViewModel.trigger(.onChangePeriod(period))
        }
        cell.setData(header: headerData, imageLoader: imageLoader)
        return cell
    }

    func makeChartCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        data: BarChartData,
        color: UIColor? = nil,
        style: BarChartValueStyle
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PetAnalyticsChartCell.identifier,
            for: indexPath
        ) as? PetAnalyticsChartCell else {
            return UICollectionViewCell()
        }

        if let color {
            cell.setData(barChartData: data, color: color, style: style)
        } else {
            cell.setData(barChartData: data, style: style)
        }

        return cell
    }

    func makeGoalCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        data: GoalCompletionData
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PetAnalyticsGoalCompetionCell.identifier,
            for: indexPath
        ) as? PetAnalyticsGoalCompetionCell else {
            return UICollectionViewCell()
        }

        cell.setData(goalCompletion: data)
        return cell
    }

    func makeStatsCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        data: PetAnalyticsStatsData
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PetAnalyticsStatsCell.identifier,
            for: indexPath
        ) as? PetAnalyticsStatsCell else {
            return UICollectionViewCell()
        }

        cell.setData(stats: data)
        return cell
    }

    func makeHistoryHeaderCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PetAnalyticsHistoryHeaderCell.identifier,
            for: indexPath
        ) as? PetAnalyticsHistoryHeaderCell else {
            return UICollectionViewCell()
        }

        cell.onTapButton = { [weak self] in
            self?.petAnalyticsViewModel.trigger(.onHistoryButtonTap)
        }
        return cell
    }

    func makeHistoryCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        data: PetAnalyticsHistoryData
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PetAnalyticsHistoryCell.identifier,
            for: indexPath
        ) as? PetAnalyticsHistoryCell else {
            return UICollectionViewCell()
        }

        cell.setData(history: data)
        return cell
    }
}
