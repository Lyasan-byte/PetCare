//
//  PetFactsCacheRepository.swift
//  PetCare
//
//  Created by Ляйсан on 4/5/26.
//

import Foundation

protocol PetFactsCacheRepository {
    func save(fact: PetFact, breed: String) throws
    func getFact(for breed: String) throws -> PetFact?
}
