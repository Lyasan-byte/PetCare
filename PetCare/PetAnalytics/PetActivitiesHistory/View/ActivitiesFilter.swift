//
//  ActivitiesFilter.swift
//  PetCare
//
//  Created by Ляйсан on 2/5/26.
//

import Foundation

enum ActivitiesFilter: String, Identifiable, CaseIterable {
    case all = "ALL"
    case walk = "WALK"
    case grooming = "GROOMING"
    case vet = "VET"
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .all:
            return L10n.ActivitiesFilter.all
        case .walk:
            return L10n.ActivitiesFilter.walk
        case .grooming:
            return L10n.ActivitiesFilter.grooming
        case .vet:
            return L10n.ActivitiesFilter.vet
        }
    }
}
