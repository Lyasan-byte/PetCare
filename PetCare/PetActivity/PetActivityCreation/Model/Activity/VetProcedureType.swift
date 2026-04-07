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
            "Check Up"
        case .vaccination:
            "Vaccination"
        case .surgery:
            "Surgery"
        case .dental:
            "Dental"
        case .other:
            "Other"
        }
    }
}
