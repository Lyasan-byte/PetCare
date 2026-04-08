//
//  UserProfileEditState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

struct UserProfileEditDisplayData {
    let userId: String
    let email: String?

    var firstName: String
    var lastName: String
    var existingPhotoUrl: String?
    var selectedPhotoData: Data?
    var isSaving: Bool

    var title: String {
        NSLocalizedString("user.profile.edit.navigation.title", comment: "")
    }

    var isSaveEnabled: Bool {
        !isSaving &&
            !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(user: UserProfileUser) {
        self.userId = user.id
        self.email = user.email
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.existingPhotoUrl = user.avatarURLString
        self.selectedPhotoData = nil
        self.isSaving = false
    }
}

enum UserProfileEditState {
    case loading
    case content(UserProfileEditDisplayData)
    case error(String)
}
