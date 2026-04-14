//
//  PetFact.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation

struct PetFact {
    let name: String
    let locations: [String]
    let diet: String?
    let commonName: String?
    let skinType: String?
    let group: String?
    let slogan: String?
    let lifespan: String?
    let temperament: String?
    let weight: String?

    var petName: String {
        commonName ?? name
    }

    var characteristic: String {
        slogan ?? temperament ?? ""
    }
}
