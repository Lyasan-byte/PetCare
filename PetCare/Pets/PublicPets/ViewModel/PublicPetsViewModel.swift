//
//  PublicPetsViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Foundation
import Combine

final class PublicPetsViewModel: PublicPetsViewModeling {
    @Published var state: PublicPetsState {
        didSet {
            stateDidChange.send()
        }
    }
    
    private(set) var stateDidChange = ObservableObjectPublisher()
    private var bag = Set<AnyCancellable>()
    private let moduleOutput: PublicPetsModuleOutput?
    
    init(moduleOutput: PublicPetsModuleOutput) {
        self.state = PublicPetsState()
        self.moduleOutput = moduleOutput
    }
    
    func trigger(_ intent: PublicPetsIntent) {
        switch intent {
        case .onDidLoad:
            fetchPets()
        case .onPetCardTap(let pet):
            moduleOutput?.moduleWantsToOpenPetProfile(pet)
        }
    }
    
    private func fetchPets() {
        
    }
    
    
    
}
