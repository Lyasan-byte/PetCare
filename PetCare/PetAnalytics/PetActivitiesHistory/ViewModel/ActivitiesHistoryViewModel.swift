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
        }
    }
    
    private func fetchActivities() {
        guard content.hasMore else { return }
        
        let isFirstPage = lastDocumentSnapshot == nil
        
        if isFirstPage {
            state = .loading
        }
        
        activitiesHistoryRepository
            .fetchActivities(for: content.petId, after: lastDocumentSnapshot, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] page in
                guard let self else { return }
                
                let historyData = buildContent(from: page.activities)
                if isFirstPage {
                    self.content.activities = historyData
                } else {
                    self.content.activities.append(contentsOf: historyData)
                }
                
                self.lastDocumentSnapshot = page.lastDocument
                self.content.hasMore = page.hasMore
                
                self.state = .content(self.content)
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
}
