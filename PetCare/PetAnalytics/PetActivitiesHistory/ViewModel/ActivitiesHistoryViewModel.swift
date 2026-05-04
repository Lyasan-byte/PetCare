//
//  ActivitiesHistoryViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Combine
import Foundation
import FirebaseFirestore

final class ActivitiesHistoryViewModel: ActivitiesHistoryViewModeling {
    @Published private(set) var state: ActivitiesHistoryState {
        didSet {
            stateDidChange.send()
        }
    }
    
    private(set) var stateDidChange =  ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()
    private var content: ActivitiesHistoryContent
    private var fetchedActivities: [PetActivity] = []
    private var lastDocumentSnapshot: DocumentSnapshot?
    
    private let activitiesHistoryRepository: ActivitiesHistoryRepository
    private let contentBuilder: ActivitiesHistoryBuilding
    private let pageSize = 10
    
    init(
        petId: String,
        activitiesHistoryRepository: ActivitiesHistoryRepository,
        contentBuilder: ActivitiesHistoryBuilding
    ) {
        self.content = ActivitiesHistoryContent(petId: petId)
        self.state = .content(content)
        self.activitiesHistoryRepository = activitiesHistoryRepository
        self.contentBuilder = contentBuilder
    }
    
    func trigger(_ intent: ActivitiesHistoryIntent) {
        switch intent {
        case .onDidLoad:
            fetchActivities()
        case .onReachedItem(let index):
            if shouldLoadMore(index) {
                fetchActivities()
            }
        case .onDismissAlert:
            state = .content(content)
        case .onChangeFilterOption(let option):
            guard content.filterOption != option else { return }
            content.filterOption = option
            resetAndFetch()
        case .onLanguageDidChange:
            rebuildLocalizedContent()
        }
    }
    
    private func resetAndFetch() {
        bag.removeAll()
        lastDocumentSnapshot = nil
        content.hasMore = true
        content.activities = []
        fetchedActivities = []
        fetchActivities()
    }
    
    private func fetchActivities() {
        guard content.hasMore else { return }
        
        let isFirstPage = lastDocumentSnapshot == nil
        
        if isFirstPage {
            state = .loading
        }
        
        activitiesHistoryRepository
            .fetchActivities(
                for: content.petId,
                after: lastDocumentSnapshot,
                pageSize: pageSize,
                filter: content.filterOption
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] page in
                guard let self else { return }
                
                if page.activities.isEmpty {
                    self.state = .empty(L10n.ActivitiesHistory.empty(self.content.filterOption.title))
                } else {
                    if isFirstPage {
                        self.fetchedActivities = page.activities
                    } else {
                        self.fetchedActivities.append(contentsOf: page.activities)
                    }

                    let historyData = buildContent(from: self.fetchedActivities)
                    if isFirstPage {
                        self.content.activities = historyData
                    } else {
                        self.content.activities = historyData
                    }
                    
                    self.lastDocumentSnapshot = page.lastDocument
                    self.content.hasMore = page.hasMore
                    
                    self.state = .content(self.content)
                }                
            }
            .store(in: &bag)
    }
    
    private func shouldLoadMore(_ index: Int) -> Bool {
        let threshold = max(content.activities.count - 3, 0)
        return index >= threshold
    }
    
    private func buildContent(from activities: [PetActivity]) -> [PetAnalyticsHistoryData] {
        contentBuilder.buildHistoryData(from: activities)
    }

    private func rebuildLocalizedContent() {
        if fetchedActivities.isEmpty {
            if case .empty = state {
                state = .empty(L10n.ActivitiesHistory.empty(content.filterOption.title))
            }
            return
        }

        content.activities = buildContent(from: fetchedActivities)
        state = .content(content)
    }
}
