//
//  PetProfileViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 31/3/26.
//

import Foundation
import Combine

final class PetProfileViewModel: PetProfileViewModeling {
    @Published private(set) var state: PetProfileState {
        didSet {
            stateDidChange.send()
        }
    }

    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()

    private let petFactsRepository: PetFactsRepository
    private weak var moduleOutput: PetProfileModuleOutput?

    init(
        pet: Pet,
        petFactsRepository: PetFactsRepository,
        moduleOutput: PetProfileModuleOutput
    ) {
        self.state = PetProfileState(pet: pet)
        self.petFactsRepository = petFactsRepository
        self.moduleOutput = moduleOutput
    }

    func trigger(_ intent: PetProfileIntent) {
        switch intent {
        case .onEditTap:
            moduleOutput?.moduleWantsToOpenEdit(state.pet)

        case .onAnalyticsTap:
            moduleOutput?.moduleWantsToOpenAnalytics(state.pet)

        case .onBreedTap:
            getPetInfo(breed: state.pet.breed)

        case .onCloseTap:
            moduleOutput?.moduleWantsToClose()

        case .onCreateActivityTap:
            moduleOutput?.moduleWantsToOpenAddActivity(state.pet)
        }
    }

    func update(_ pet: Pet) {
        state.pet = pet
    }

    private func getPetInfo(breed: String) {
        petFactsRepository.fetcFact(for: breed)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure = completion {
                    print(completion)
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }

                self.state.petFact = result
                self.moduleOutput?.moduleWantsToOpenBreedFactSheet(result)
            }
            .store(in: &bag)
    }
}
