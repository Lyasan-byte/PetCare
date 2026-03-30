//
//  PetsMainRoute.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation

enum PetsMainRoute {
    case showQuickAction(QuickActionCellType)
    case showPet(Pet)
    case showAddPet
    case showError(String)
}
