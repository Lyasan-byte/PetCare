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

    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()
    private weak var moduleOutput: PetsMainModuleOutput?

    private let petRepository: PetRepository
    private let tipRepository: TipRepository

    init(
        petRepository: PetRepository,
        tipRepository: TipRepository,
        moduleOutput: PetsMainModuleOutput,
        ownerId: String
    ) {
        self.petRepository = petRepository
        self.tipRepository = tipRepository
        self.moduleOutput = moduleOutput
        self.state = PetsMainState(ownerId: ownerId)
    }

    func trigger(_ intent: PetsMainIntent) {
        switch intent {
        case .viewDidLoad:
            getPets()
            getTips()
        case .onTipTap:
            state.tipText = state.tips.randomElement()?.text ?? Tip.defaultTip
        case .onAddPetTap:
            moduleOutput?.petsMainModuleDidRequestAddPet()
        case .refreshPets:
            getPets()
        case .onPetTap(let pet):
            moduleOutput?.petsMainModuleDidRequestOpenPet(pet)
        case .onDismissAlert:
            state.errorMessage = nil
        case .onAddActivity(let activity):
            moduleOutput?.petsMainModuleDidRequestAddActivity(activity)
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
                    self.state.errorMessage = error.localizedDescription
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
