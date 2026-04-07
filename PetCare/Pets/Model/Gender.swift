//
//  Gender.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import Foundation

enum Gender: String, Codable, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"
}

extension Gender {
    var title: String {
        switch self {
        case .male:
            return L10n.Pets.Gender.male
        case .female:
            return L10n.Pets.Gender.female
        }
    }
}
