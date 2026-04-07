//
//  RegistrationCompletionIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import Foundation

enum RegistrationCompletionIntent {
    case onDidLoad
    case onChangeFirstName(String)
    case onChangeLastName(String)
    case onPickPhoto(Data?)
    case onSave
    case onDismissAlert
}
