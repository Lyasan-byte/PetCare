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
    private var bag = Set<AnyCancellable>()
    private weak var moduleOutput: PetFormModuleOutput?
    
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository, mode: PetFormMode, moduleOutput: PetFormModuleOutput) {
        self.petRepository = petRepository
        self.moduleOutput = moduleOutput
        
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
        case .onChangeName(let name):
            state.name = name
        case .onChangeBreed(let breed):
            state.breed = breed
        case .onChangeWeight(let weight):
            state.weightText = weight
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
            state.isDeleteConfirmationPresented = true
        case .onConfirmDelete:
            state.isDeleteConfirmationPresented = false
            delete()
        case .onCloseTap:
            moduleOutput?.petFormModuleDidClose()
        case .onDismissAlert:
            state.errorMessage = nil
            state.isDeleteConfirmationPresented = false
        }
    }
    
    private func validateForm() -> String? {
        let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBreed = state.breed.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedWeight = state.weightText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        if trimmedName.isEmpty {
            return L10n.Pets.Form.Validation.enterPetName
        }

        if trimmedBreed.isEmpty {
            return L10n.Pets.Form.Validation.enterBreed
        }

        if normalizedWeight.isEmpty {
            return L10n.Pets.Form.Validation.enterWeight
        }

        guard let weight = Double(normalizedWeight), weight > 0 else {
            return L10n.Pets.Form.Validation.weightGreaterThanZero
        }

        return nil
    }
    
    private func save() {
        if let validationError = validateForm() {
            state.errorMessage = validationError
            return
        }
        
        guard let pet = makePetFromState() else {
            state.errorMessage = L10n.Pets.Form.Validation.checkFormFields
            return
        }

        state.isSaving = true
        
        petRepository.save(pet: pet, selectedPhoto: state.selectedPhotoData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                state.isSaving = false
                
                if case .failure(let error) = completion {
                    state.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] pet in
                self?.moduleOutput?.petFormModuleDidSave(pet)
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
                    state.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.moduleOutput?.petFormModuleDidDelete()
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
