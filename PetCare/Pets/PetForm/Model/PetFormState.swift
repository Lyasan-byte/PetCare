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
    var errorMessage: String?
    var isDeleteConfirmationPresented: Bool

    var title: String {
        switch mode {
        case .create:
            return "Create Pet"
        case .edit:
            return "Edit Profile"
        }
    }

    var showsDeleteButton: Bool {
        if case .edit = mode {
            return true
        }
        return false
    }

    var isSaveEnabled: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBreed = breed.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedWeight = weightText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        let isNameValid = !trimmedName.isEmpty
        let isBreedValid = !trimmedBreed.isEmpty
        let isWeightValid = Double(normalizedWeight).map { $0 > 0 } ?? false

        return !isSaving && isNameValid && isBreedValid && isWeightValid
    }

    init(mode: PetFormMode, petId: String) {
        self.mode = mode
        self.petId = petId

        switch mode {
        case .create:
            self.name = ""
            self.breed = ""
            self.weightText = ""
            self.dateOfBirth = Date()
            self.gender = .male
            self.note = ""
            self.iconStatus = .none
            self.isPublicProfile = false
            self.existingPhotoUrl = nil
            self.selectedPhotoData = nil
            self.isSaving = false
            self.errorMessage = nil
            self.isDeleteConfirmationPresented = false

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
            self.errorMessage = nil
            self.isDeleteConfirmationPresented = false
        }
    }
}
