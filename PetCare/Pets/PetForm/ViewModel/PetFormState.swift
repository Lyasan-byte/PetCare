//
//  PetFormState.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Foundation

enum PetFormMode: Equatable {
    case create(ownerId: String)
    case edit(Pet)
}

struct PetFormState {
    var mode: PetFormMode
    var petId: String
    var name: String
    var breed: String
    var weightText: String
    var dateOfBirth: Date
    var gender: Gender
    var note: String
    var iconStatus: PetIconStatus
    var isPublicProfile: Bool
    var existingPhotoUrl: String?
    var selectedPhotoData: Data?
    
    var isSaving: Bool
    
    var nameError: String?
    var breedError: String?
    var weightError: String?
    
    var title: String {
        switch mode {
        case .create(_):
            "Create Pet"
        case .edit(_):
            "Edit Profile"
        }
    }
    
    var showsDeleteButton: Bool {
        if case .edit = mode {
            return true
        }
        return false
    }
    
    var isSaveEnabled: Bool {
        let isNameValid = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isBreedValid = !breed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isWeightValid = weightError == nil && !weightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return !isSaving && isNameValid && isBreedValid && isWeightValid
    }
    
    init(mode: PetFormMode, petId: String) {
        self.mode = mode
        self.petId = petId
        
        switch mode {
        case .create(_):
            self.name = ""
            self.breed = ""
            self.weightText = ""
            self.dateOfBirth = Date()
            self.gender = .male
            self.note = ""
            self.iconStatus = .heart
            self.isPublicProfile = false
            self.existingPhotoUrl = nil
            self.selectedPhotoData = nil
            self.isSaving = false
            self.nameError = nil
            self.breedError = nil
            self.weightError = nil
            
        case .edit(let pet):
            self.name = pet.name
            self.breed = pet.breed
            self.weightText = String(pet.weight)
            self.dateOfBirth = pet.dateOfBirth
            self.gender = pet.gender
            self.note = pet.note
            self.iconStatus = pet.iconStatus
            self.isPublicProfile = pet.isPublic
            self.existingPhotoUrl = pet.photoUrl
            self.selectedPhotoData = nil
            self.isSaving = false
            self.nameError = nil
            self.breedError = nil
            self.weightError = nil
        }
    }
}
