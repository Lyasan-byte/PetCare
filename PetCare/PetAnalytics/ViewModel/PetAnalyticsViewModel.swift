//
//  PetAnalyticsViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Foundation
import Combine

final class PetAnalyticsViewModel: PetAnalyticsViewModeling {
    @Published private(set) var state: PetAnalyticsState {
        didSet {
            stateDidChange.send()
        }
    }
    
    private let petInput: PetAnalyticsInput
    private let petAnalyticsRepository: PetAnalyticsRepository
    private let contentBuilder: PetAnalyticsBuilding
    
    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()
    private var allActivities: [PetActivity] = []
    private var content: PetAnalyticsContent
    
    init(
        petInput: PetAnalyticsInput,
        petAnalyticsRepository: PetAnalyticsRepository,
        contentBuilder: PetAnalyticsBuilding
    ) {
        self.petInput = petInput
        self.state = .loading
        self.petAnalyticsRepository = petAnalyticsRepository
        self.contentBuilder = contentBuilder
        self.content = PetAnalyticsContent(pet: petInput.pet)
    }
    
    func trigger(_ intent: PetAnalyticsIntent) {
        switch intent {
        case .onDidLoad:
            fetchActivities()
        case .onChangePeriod(let petAnalyticsPeriod):
            content.selectedPeriod = petAnalyticsPeriod
            fetchActivities()
        }
    }
    
    private func fetchActivities() {
        state = .loading
        
        let range = content.selectedPeriod.dateRange()
        petAnalyticsRepository
            .fetchActivities(
                for: petInput.petId,
                startDate: range.start,
                endDate: range.end
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] activities in
                guard let self else { return }
                self.allActivities = activities
                
                if self.allActivities.isEmpty {
                    self.state = .empty
                } else {
                    self.rebuildContent()
                }
            }
            .store(in: &bag)
    }
    
    private func rebuildContent() {
        let newContent = contentBuilder.buildContent(
            petId: petInput.petId,
            pet: petInput.pet,
            petActivities: allActivities,
            period: self.content.selectedPeriod
        )
        self.state = .content(newContent)
    }
}
