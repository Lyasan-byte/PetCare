//
//  UserProfileUser.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Foundation

struct UserProfileUser {
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let avatarURLString: String?

    var fullName: String {
        let parts = [firstName, lastName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if parts.isEmpty {
            return NSLocalizedString("user.profile.name.placeholder", comment: "")
        }

        return parts.joined(separator: " ")
    }
}
