//
//  PetsMainViewIntent.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation

enum PetsMainIntent {
    case viewDidLoad
    case onTipTap
    case onAddActivity(PetActivityType)
    case onAddPetTap
    case onPetTap(Pet)
    case refreshPets
    case onDismissAlert
}
