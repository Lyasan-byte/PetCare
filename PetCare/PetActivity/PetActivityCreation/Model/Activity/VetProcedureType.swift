//
//  VetProcedureType.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import Foundation

enum VetProcedureType: String, Codable, CaseIterable {
    case checkUp = "CHECKUP"
    case vaccination = "VACCINATION"
    case surgery = "SURGERY"
    case dental = "DENTAL"
    case other = "OTHER"
    
    var title: String {
        switch self {
        case .checkUp:
            L10n.Pets.Vet.checkUp
        case .vaccination:
            L10n.Pets.Vet.vaccination
        case .surgery:
            L10n.Pets.Vet.surgery
        case .dental:
            L10n.Pets.Vet.dental
        case .other:
            L10n.Pets.Vet.other
        }
    }
}
