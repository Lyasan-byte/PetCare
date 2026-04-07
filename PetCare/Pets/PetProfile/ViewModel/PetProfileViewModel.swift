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
    private weak var moduleOutput: PetProfileModuleOutput?
    
    init(pet: Pet, moduleOutput: PetProfileModuleOutput) {
        self.state = PetProfileState(pet: pet)
        self.moduleOutput = moduleOutput
    }
    
    func trigger(_ intent: PetProfileIntent) {
        switch intent {
        case .onEditTap:
            moduleOutput?.petProfileModuleDidRequestEdit(state.pet)
        case .onAnalyticsTap:
            moduleOutput?.petProfileModuleDidRequestAnalytics(state.pet)
        case .onBreedTap:
            getPetInfo(breed: state.pet.breed)
        case .onCloseTap:
            moduleOutput?.petProfileModuleDidClose()
        }
    }
    
    func update(_ pet: Pet) {
        state.pet = pet
    }
    
    private func getPetInfo(breed: String) {
        
    }   
}
