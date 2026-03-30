//
//  PetsMainViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation
import Combine

final class PetsMainViewModel: PetsMainViewModeling {
    @Published private(set) var state: PetsMainState {
        didSet {
            stateDidChange.send()
        }
    }
    
    var routePublisher: AnyPublisher<PetsMainRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    private(set) var stateDidChange = ObservableObjectPublisher()
    private let routeSubject = PassthroughSubject<PetsMainRoute, Never>()
    private var bag = Set<AnyCancellable>()
    private let petRepository: PetRepository
    private let tipRepository: TipRepository
    
    init(petRepository: PetRepository, tipRepository: TipRepository, ownerId: String) {
        self.state = PetsMainState(ownerId: ownerId)
        self.petRepository = petRepository
        self.tipRepository = tipRepository
    }
    
    func trigger(_ intent: PetsMainIntent) {
        switch intent {
        case .viewDidLoad:
            getPets()
            getTips()
        case .onTipTap:
            state.tipText = state.tips.randomElement()?.text ?? Tip.defaultTip
        case .onAddPetTap:
            routeSubject.send(.showAddPet)
        case .refreshPets:
            getPets()
        case .onPetTap(let pet):
            routeSubject.send(.showPet(pet))
        }
    }
    
    private func getTips() {
        tipRepository.fetchTips()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                    self?.state.tipText = Tip.defaultTip
                }
            } receiveValue: { [weak self] tips in
                self?.state.tips = tips
                self?.state.tipText = tips.randomElement()?.text ?? Tip.defaultTip
            }
            .store(in: &bag)
    }
    
    private func getPets() {
        state.isLoading = true
        
        petRepository.fetchPets(for: state.ownerId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(let error) = completion {
                    self.routeSubject.send(.showError(error.localizedDescription))
                    self.state.isLoading = false
                }
            } receiveValue: { [weak self] pets in
                guard let self else { return }
                self.state.pets = pets
                self.state.isEmptyState = pets.isEmpty
                self.state.isLoading = false
            }
            .store(in: &bag)
    }
}
