//
//  PetFormRoute.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Foundation

enum PetFormRoute {
    case showDeleteConfirmation
    case showErrorAlert(String)
    case didSavePet(Pet)
    case didDeletePet
    case close
}
