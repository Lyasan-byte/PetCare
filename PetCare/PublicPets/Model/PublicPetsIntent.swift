//
//  PublicPetsIntent.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Foundation

enum PublicPetsIntent {
    case onDidLoad
    case onPetCardTap(Pet)
    case onReachedItem(index: Int)
    case onDismissAlert
}
