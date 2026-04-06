//
//  RegistrationCompletionState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import Foundation

struct RegistrationCompletionState {
    var userId: String?
    var email: String?
    var firstName: String
    var lastName: String
    var existingPhotoUrl: String?
    var selectedPhotoData: Data?
    var isLoading: Bool
    var errorMessage: String?

    var title: String {
        NSLocalizedString("auth.registration_completion.title", comment: "")
    }

    var subtitle: String {
        NSLocalizedString("auth.registration_completion.subtitle", comment: "")
    }

    var buttonTitle: String {
        NSLocalizedString("auth.registration_completion.button", comment: "")
    }

    var isSaveEnabled: Bool {
        !isLoading &&
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init() {
        self.userId = nil
        self.email = nil
        self.firstName = ""
        self.lastName = ""
        self.existingPhotoUrl = nil
        self.selectedPhotoData = nil
        self.isLoading = false
        self.errorMessage = nil
    }
}
