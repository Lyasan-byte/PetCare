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

    var displayName: String? {
        let parts = [firstName, lastName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !parts.isEmpty else { return nil }
        return parts.joined(separator: " ")
    }

    var avatarURL: URL? {
        guard let avatarURLString,
              let url = URL(string: avatarURLString) else {
            return nil
        }

        return url
    }

    var fullName: String {
        displayName ?? NSLocalizedString("user.profile.name.placeholder", comment: "")
    }
}
