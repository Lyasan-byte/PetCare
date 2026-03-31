//
//  PetFormViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Foundation
import Combine

final class PetFormViewModel: PetFormViewModeling {
    @Published private(set) var state: PetFormState {
        didSet {
            stateDidChange.send()
        }
    }
    
    private(set) var stateDidChange = ObservableObjectPublisher()
    
    var routePublisher: AnyPublisher<PetFormRoute, Never> {
        routeSubject.eraseToAnyPublisher()
    }
    
    private let petRepository: PetRepository
    private var routeSubject = PassthroughSubject<PetFormRoute, Never>()
    private var bag = Set<AnyCancellable>()
    
    init(petRepository: PetRepository, mode: PetFormMode) {
        self.petRepository = petRepository
        
        let petId: String
        switch mode {
        case .create:
            petId = petRepository.makeNewPetId()
        case .edit(let pet):
            petId = pet.id
        }
        
        self.state = State(mode: mode, petId: petId)
    }
    
    func trigger(_ intent: PetFormIntent) {
        switch intent {
        case .onDidLoad:
            validate()
        case .onChangeName(let name):
            state.name = name
            validate()
        case .onChangeBreed(let breed):
            state.breed = breed
            validate()
        case .onChangeWeight(let weight):
            state.weightText = weight
            validate()
        case .onChangeDate(let date):
            state.dateOfBirth = date
        case .onChangeGender(let gender):
            state.gender = gender
        case .onChangeNote(let note):
            state.note = note
        case .onChangeIconStatus(let petIconStatus):
            state.iconStatus = petIconStatus
        case .onChangeIsPublicProfile(let isPublic):
            state.isPublicProfile = isPublic
        case .onPickPhoto(let data):
            state.selectedPhotoData = data
        case .onSave:
            save()
        case .onDelete:
            routeSubject.send(.showDeleteConfirmation)
        case .onConfirmDelete:
            delete()
        }
    }
    
    private func validate() {
        let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBreed = state.breed.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedWeight = state.weightText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        
        state.nameError = trimmedName.isEmpty ? L10n.Pets.Form.Validation.enterPetName : nil
        state.breedError = trimmedBreed.isEmpty ? L10n.Pets.Form.Validation.enterBreed : nil
        
        if normalizedWeight.isEmpty {
            state.weightError = L10n.Pets.Form.Validation.enterWeight
        } else if let value = Double(normalizedWeight), value > 0 {
            state.weightError = nil
        } else {
            state.weightError = L10n.Pets.Form.Validation.weightGreaterThanZero
        }
    }
    
    private func save() {
        validate()
        
        guard state.isSaveEnabled else { return }
        guard let pet = makePetFromState() else {
            routeSubject.send(.showErrorAlert(L10n.Pets.Form.Validation.checkFormFields))
            return
        }
        
        state.isSaving = true
        
        petRepository.save(pet: pet)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                state.isSaving = false
                
                if case .failure(let error) = completion {
                    routeSubject.send(.showErrorAlert(error.localizedDescription))
                }
            } receiveValue: { [weak self] pet in
                self?.routeSubject.send(.didSavePet(pet))
            }
            .store(in: &bag)
    }
    
    private func delete() {
        state.isSaving = true
        
        petRepository.delete(petId: state.petId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.state.isSaving = false
                
                if case .failure(let error) = completion {
                    self.routeSubject.send(.showErrorAlert(error.localizedDescription))
                }
            } receiveValue: { [weak self] in
                self?.routeSubject.send(.didDeletePet)
            }
            .store(in: &bag)
    }
    
    private func makePetFromState() -> Pet? {
        let normalizedWeight = state.weightText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let weight = Double(normalizedWeight), weight > 0 else { return nil }
        
        switch state.mode {
        case .create(let ownerId):
            return Pet(
                id: state.petId,
                name: state.name.trimmingCharacters(in: .whitespacesAndNewlines),
                breed: state.breed.trimmingCharacters(in: .whitespacesAndNewlines),
                weight: weight,
                dateOfBirth: state.dateOfBirth,
                gender: state.gender,
                note: state.note.trimmingCharacters(in: .whitespacesAndNewlines),
                photoUrl: state.existingPhotoUrl,
                ownerId: ownerId,
                isPublic: state.isPublicProfile,
                iconStatus: state.iconStatus
            )
            
        case .edit(let pet):
            return Pet(
                id: pet.id,
                name: state.name.trimmingCharacters(in: .whitespacesAndNewlines),
                breed: state.breed.trimmingCharacters(in: .whitespacesAndNewlines),
                weight: weight,
                dateOfBirth: state.dateOfBirth,
                gender: state.gender,
                note: state.note.trimmingCharacters(in: .whitespacesAndNewlines),
                photoUrl: state.existingPhotoUrl,
                ownerId: pet.ownerId,
                isPublic: state.isPublicProfile,
                gameScore: pet.gameScore,
                iconStatus: state.iconStatus
            )
        }
    }
}
