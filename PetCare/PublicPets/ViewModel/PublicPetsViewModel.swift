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
    @Published var state: PublicPetsState {
        didSet {
            stateDidChange.send()
        }
    }
    
    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()
    
    private var lastDocument: DocumentSnapshot?
    private let pageSize = 10
    
    private let petRepository: PublicPetRepository
    private let moduleOutput: PublicPetsModuleOutput?
    
    init(petRepository: PublicPetRepository, moduleOutput: PublicPetsModuleOutput) {
        self.state = PublicPetsState()
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
            state.errorMessage = nil
        }
    }
    
    private func fetchPets() {
        guard state.hasMore,
              !state.isLoading,
              !state.isLoadingMore else { return }
        
        let firstPage = lastDocument == nil
        
        if firstPage {
            state.isLoading = true
        } else {
            state.isLoadingMore = true
        }
        
        petRepository.fetch(after: lastDocument, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                state.isLoading = false
                state.isLoadingMore = false
                
                if case .failure(let error) = completion {
                    self.state.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }
                
                if firstPage {
                    self.state.pets = result.pets
                } else {
                    self.state.pets.append(contentsOf: result.pets)
                }
                
                self.state.hasMore = result.hasMore
                self.lastDocument = result.lastDocument
            }
            .store(in: &bag)
    }
    
    private func shouldLoadMore(_ index: Int) -> Bool {
        let threshold = max(state.pets.count - 3, 0)
        return index >= threshold
    }
}
