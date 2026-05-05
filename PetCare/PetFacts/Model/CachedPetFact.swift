//
//  CachedPetFact.swift
//  PetCare
//
//  Created by Ляйсан on 4/5/26.
//

import SwiftData
import Foundation

@Model
final class CachedPetFact {
    @Attribute(.unique)
    var id: String
    var name: String
    var locations: [String]
    var diet: String?
    var commonName: String?
    var skinType: String?
    var group: String?
    var slogan: String?
    var lifespan: String?
    var temperament: String?
    var weight: String?
    
    init(
        id: String,
        name: String,
        locations: [String],
        diet: String? = nil,
        commonName: String? = nil,
        skinType: String? = nil,
        group: String? = nil,
        slogan: String? = nil,
        lifespan: String? = nil,
        temperament: String? = nil,
        weight: String? = nil
    ) {
        self.id = id
        self.name = name
        self.locations = locations
        self.diet = diet
        self.commonName = commonName
        self.skinType = skinType
        self.group = group
        self.slogan = slogan
        self.lifespan = lifespan
        self.temperament = temperament
        self.weight = weight
    }
    
    convenience init(breed: String, petFact: PetFact) {
        self.init(
            id: breed,
            name: petFact.name,
            locations: petFact.locations,
            diet: petFact.diet,
            commonName: petFact.commonName,
            skinType: petFact.skinType,
            group: petFact.group,
            slogan: petFact.slogan,
            lifespan: petFact.lifespan,
            temperament: petFact.temperament,
            weight: petFact.weight
        )
    }
    
    func toDomain() -> PetFact {
        PetFact(
            name: name,
            locations: locations,
            diet: diet,
            commonName: commonName,
            skinType: skinType,
            group: group,
            slogan: slogan,
            lifespan: lifespan,
            temperament: temperament,
            weight: weight
        )
    }
}
