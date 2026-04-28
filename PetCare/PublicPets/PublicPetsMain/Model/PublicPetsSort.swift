//
//  PublicPetsSort.swift
//  PetCare
//
//  Created by Ляйсан on 16/4/26.
//

import Foundation

enum PublicPetsSort: Int, CaseIterable {
    case gameScore
    case name
    
    var title: String {
        switch self {
        case .gameScore:
            return L10n.PublicPets.Sort.gameScore
        case .name:
            return L10n.PublicPets.Sort.name
        }
    }
}
