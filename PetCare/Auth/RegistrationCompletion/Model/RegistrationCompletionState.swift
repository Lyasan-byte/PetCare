//
//  RegistrationCompletionState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import Foundation

struct RegistrationCompletionDisplayData {
    var userId: String?
    var email: String?
    var firstName: String
    var lastName: String
    var existingPhotoUrl: String?
    var selectedPhotoData: Data?

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
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    static let empty = RegistrationCompletionDisplayData(
        userId: nil,
        email: nil,
        firstName: "",
        lastName: "",
        existingPhotoUrl: nil,
        selectedPhotoData: nil
    )
}

enum RegistrationCompletionState {
    case loading
    case content(RegistrationCompletionDisplayData)
    case error(String)
}
