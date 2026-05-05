//
//  SwiftDataPetFactsCacheService.swift
//  PetCare
//
//  Created by Ляйсан on 4/5/26.
//

import SwiftData
import Foundation

final class SwiftDataPetFactsCacheService: PetFactsCacheRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(fact: PetFact, breed: String) throws {
        let key = breed.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cachedFact = CachedPetFact(breed: key, petFact: fact)

        modelContext.insert(cachedFact)
        try modelContext.save()
    }
    
    func getFact(for breed: String) throws -> PetFact? {
        let key = breed.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let fetchDescriptor = FetchDescriptor<CachedPetFact>(
            predicate: #Predicate { $0.id == key })
        return try modelContext.fetch(fetchDescriptor).first?.toDomain()
    }
}
