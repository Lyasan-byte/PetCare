//
//  PublicPetsViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Foundation
import FirebaseFirestore
import Combine

final class PublicPetsViewModel: PublicPetsViewModeling {
    @Published private(set) var state: PublicPetsState {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()
    private var lastDocument: DocumentSnapshot?
    private var sortingMethod: PublicPetsSort = .gameScore
    private var content: PublicPetsContent
    private weak var moduleOutput: PublicPetsModuleOutput?

    private let userId: String
    private let pageSize = 10
    private let petRepository: PublicPetRepository

    init(userId: String, petRepository: PublicPetRepository, moduleOutput: PublicPetsModuleOutput) {
        self.userId = userId
        self.content = PublicPetsContent()
        self.state = .content(content)
        self.petRepository = petRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: PublicPetsIntent) {
        switch intent {
        case .onDidLoad:
            fetchPets()
        case .onPetCardTap(let pet):
            moduleOutput?.moduleWantsToOpenPetProfile(pet)
        case .onReachedItem(let index):
            guard shouldLoadMore(index) else { return }
            fetchPets()
        case .onDismissAlert:
            state = .content(content)
        case .onSortingMethodChange(let sortOption):
            guard sortingMethod != sortOption else { return }
            self.sortingMethod = sortOption
            resetAndFetchPets()
        }
    }
    
    private func resetAndFetchPets() {
        bag.removeAll()
        lastDocument = nil
        content.pets = []
        content.hasMore = true
        fetchPets()
    }

    private func fetchPets() {
        guard content.hasMore else { return }
        let firstPage = lastDocument == nil

        if firstPage {
            state = .loading
        }
        
        petRepository.fetch(after: lastDocument, pageSize: pageSize, sort: sortingMethod)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }

                let filteredPets = result.pets.filter { $0.ownerId != self.userId }
                if firstPage {
                    self.content.pets = filteredPets
                } else {
                    self.content.pets.append(contentsOf: filteredPets)
                }

                self.content.hasMore = result.hasMore
                self.lastDocument = result.lastDocument
                self.state = .content(self.content)
            }
            .store(in: &bag)
    }

    private func shouldLoadMore(_ index: Int) -> Bool {
        let threshold = max(content.pets.count - 3, 0)
        return index >= threshold
    }
}
