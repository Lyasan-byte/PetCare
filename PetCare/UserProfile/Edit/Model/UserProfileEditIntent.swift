//
//  UserProfileEditIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

enum UserProfileEditIntent {
    case onChangeFirstName(String)
    case onChangeLastName(String)
    case onPickPhoto(Data?)
    case onSave
    case onDismissAlert
}
