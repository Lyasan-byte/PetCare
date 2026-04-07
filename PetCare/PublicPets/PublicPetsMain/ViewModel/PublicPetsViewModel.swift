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
    private var content: PublicPetsContent
    private weak var moduleOutput: PublicPetsModuleOutput?
    
    private let pageSize = 10
    private let petRepository: PublicPetRepository
    
    
    init(petRepository: PublicPetRepository, moduleOutput: PublicPetsModuleOutput) {
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
        }
    }
    
    private func fetchPets() {
        guard content.hasMore else { return }
        let firstPage = lastDocument == nil
        
        if firstPage {
            state = .loading
        }
        
        petRepository.fetch(after: lastDocument, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                if case .failure(let error) = completion {
                    state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }
                
                if firstPage {
                    self.content.pets = result.pets
                } else {
                    self.content.pets.append(contentsOf: result.pets)
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
