//
//  PetFactDTO.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation

struct PetFactDTO: Codable {
    let name: String
    let locations: [String]
    let characteristics: Characteristic
}

extension PetFactDTO {
    func toDomain() -> PetFact {
        PetFact(
            name: name,
            locations: locations,
            diet: characteristics.diet,
            commonName: characteristics.commonName,
            skinType: characteristics.skinType,
            group: characteristics.group,
            slogan: characteristics.slogan,
            lifespan: characteristics.lifespan,
            temperament: characteristics.temperament,
            weight: characteristics.weight
        )
    }
}

struct Characteristic: Codable {
    let diet: String?
    let commonName: String?
    let skinType: String?
    let group: String?
    let slogan: String?
    let lifespan: String?
    let temperament: String?
    let weight: String?
    
    enum CodingKeys: String, CodingKey {
        case diet
        case commonName = "common_name"
        case skinType = "skin_type"
        case group
        case slogan
        case lifespan
        case temperament
        case weight
    }
}
