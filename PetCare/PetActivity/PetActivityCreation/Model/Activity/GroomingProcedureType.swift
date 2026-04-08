//
//  GroomingProcedureType.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import Foundation

enum GroomingProcedureType: String, Codable, CaseIterable {
    case bath = "BATH"
    case claws = "CLAWS"
    case haircut = "HAIRCUT"
    case brushing = "BRUSHING"
    case fullService = "FULLSERVICE"
    
    var title: String {
        switch self {
        case .bath:
            L10n.Pets.Grooming.bath
        case .claws:
            L10n.Pets.Grooming.claws
        case .haircut:
            L10n.Pets.Grooming.haircut
        case .brushing:
            L10n.Pets.Grooming.brushing
        case .fullService:
            L10n.Pets.Grooming.fullService
        }
    }
}
