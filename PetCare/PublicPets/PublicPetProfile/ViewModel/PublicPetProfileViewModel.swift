//
//  PublicPetProfileViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation
import Combine

final class PublicPetProfileViewModel: PublicPetProfileViewModeling {
    @Published var state: PublicPetProfileState {
        didSet {
            stateDidChange.send()
        }
    }
    
    private(set) var stateDidChange = ObservableObjectPublisher()
    private weak var moduleOutput: PublicPetProfileModuleOutput?
    
    init(pet: Pet, moduleOutput: PublicPetProfileModuleOutput) {
        self.state = PublicPetProfileState(pet: pet)
        self.moduleOutput = moduleOutput
    }
    
    func trigger(_ intent: PublicPetProfileIntent) {
        switch intent {
        case .onDidLoad:
            fetchUser()
        case .onClose:
            moduleOutput?.moduleOutputWantsToClose()
        }
    }
    
    func fetchUser() {
        
    }
}
