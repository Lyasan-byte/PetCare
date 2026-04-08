//
//  UserProfileState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Foundation

struct UserProfileContent {
    let fullName: String
    let email: String
    let petsCountText: String
    let bestScoreText: String
    let avatarURLString: String?
}

enum UserProfileState {
    case loading
    case content(UserProfileContent)
    case error(String)
}
