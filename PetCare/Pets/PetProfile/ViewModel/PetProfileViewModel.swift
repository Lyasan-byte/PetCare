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
    
    var routePublisher: AnyPublisher<PetProfileRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    private(set) var routeSubject = PassthroughSubject<PetProfileRoute, Never>()
    private(set) var stateDidChange = ObservableObjectPublisher()
    
    init(pet: Pet) {
        self.state = PetProfileState(pet: pet)
    }
    
    func trigger(_ intent: PetProfileIntent) {
        switch intent {
        case .onEditTap(let pet):
            routeSubject.send(.showEdit(pet))
        case .onAnalyticsTap(let pet):
            routeSubject.send(.showAnalytics(pet))
        case .onBreedTap(let breed):
            getPetInfo(breed: breed)
        }
    }
    
    private func getPetInfo(breed: String) {
        
    }
    
   
    
    
}
