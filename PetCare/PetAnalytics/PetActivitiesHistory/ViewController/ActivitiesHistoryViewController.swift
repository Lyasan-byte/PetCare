//
//  ActivitiesHistoryViewController.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Combine
import UIKit

final class ActivitiesHistoryViewController: UIViewController {
    private let activitiesHistoryView = ActivitiesHistoryView()
    private let filterButton = MenuBarButton()
    
    private let activitiesHistoryViewModel: any ActivitiesHistoryViewModeling

    private var bag = Set<AnyCancellable>()
    
    private var content: ActivitiesHistoryContent? {
        guard case let .content(content) = activitiesHistoryViewModel.state else {
            return nil
        }
        return content
    }
    
    init(activitiesHistoryViewModel: any ActivitiesHistoryViewModeling) {
        self.activitiesHistoryViewModel = activitiesHistoryViewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupCollection()
        configure()
        bindViewModel()
        bindLanguageChanges()
        bindAction()

        render()
        activitiesHistoryViewModel.trigger(.onDidLoad)
    }

    private func setupCollection() {
        activitiesHistoryView.setupCollection(dataSource: self, delegate: self)
        activitiesHistoryView.registerCells()
    }

    private func setupAppearance() {
        title = L10n.ActivitiesHistory.title
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(activitiesHistoryView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            activitiesHistoryView.topAnchor.constraint(equalTo: view.topAnchor),
            activitiesHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activitiesHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activitiesHistoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configure() {
        filterButton.configure(options: ActivitiesFilter.allCases.map(\.title))
    }

    private func bindViewModel() {
        activitiesHistoryViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render()
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
    
    private func bindAction() {
        filterButton.onSelect = { [weak self] filterOption in
            let option = ActivitiesFilter.allCases[filterOption]
            self?.activitiesHistoryViewModel.trigger(.onChangeFilterOption(option))
        }
    }

    private func render() {
        switch activitiesHistoryViewModel.state {
        case .loading:
            activitiesHistoryView.setLoader(true)
            activitiesHistoryView.showEmptyView(false)
        case .content:
            activitiesHistoryView.setLoader(false)
            activitiesHistoryView.showEmptyView(false)
            activitiesHistoryView.reloadData()
        case .error(let error):
            activitiesHistoryView.setLoader(false)
            activitiesHistoryView.showEmptyView(false)
            showError(error)
        case .empty(let description):
            activitiesHistoryView.reloadData()
            activitiesHistoryView.setLoader(false)
            activitiesHistoryView.showEmptyView(true, title: description)
        }
    }

    private func reloadLocalizedView() {
        title = L10n.ActivitiesHistory.title

        let selectedIndex = ActivitiesFilter.allCases.firstIndex(of: content?.filterOption ?? .all) ?? 0
        filterButton.configure(options: ActivitiesFilter.allCases.map(\.title), selectedIndex: selectedIndex)

        activitiesHistoryViewModel.trigger(.onLanguageDidChange)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default) { [weak self] _ in
            self?.activitiesHistoryViewModel.trigger(.onDismissAlert)
        })
        present(alert, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivitiesHistoryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = ActivitiesHistorySection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .activities:
            if let content, let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetAnalyticsHistoryCell.identifier,
                for: indexPath
            ) as? PetAnalyticsHistoryCell {
                let history = content.activities[indexPath.item]
                cell.setData(history: history)
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ActivitiesHistorySection.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = ActivitiesHistorySection(rawValue: section) else { return 0 }
        
        switch section {
        case .activities:
            return content?.activities.count ?? 0
        }
    }
}

extension ActivitiesHistoryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let section = ActivitiesHistorySection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .activities:
            activitiesHistoryViewModel.trigger(.onReachedItem(indexPath.item))
        }
    }
}
