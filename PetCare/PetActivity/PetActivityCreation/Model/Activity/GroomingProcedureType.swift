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
            "Bath"
        case .claws:
            "Claws"
        case .haircut:
            "Haircut"
        case .brushing:
            "Brushing"
        case .fullService:
            "Full Service"
        }
    }
}
