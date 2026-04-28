//
//  PetCacheService.swift
//  PetCare
//
//  Created by Ляйсан on 15/4/26.
//

import Foundation
import SwiftData

final class PetCacheService: PetCacheRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ pet: Pet) throws {
        let cachedPet = CachedPet(pet: pet)
        modelContext.insert(cachedPet)
        try modelContext.save()
    }
    
    func getPets(for ownerId: String) throws -> [Pet] {
        let fetchDescriptor = FetchDescriptor<CachedPet>(
            predicate: #Predicate { $0.ownerId == ownerId }
        )
        
        let cachedPets = try modelContext.fetch(fetchDescriptor)
        return cachedPets.map { $0.toDomain() }
    }
    
    func deletePet(id: String) throws {
        guard let pet = try fetchPet(id: id) else { return }
        modelContext.delete(pet)
        try modelContext.save()
    }

    func replacePets(_ pets: [Pet], for ownerId: String) throws {
        let descriptor = FetchDescriptor<CachedPet>(
            predicate: #Predicate { $0.ownerId == ownerId }
        )
        let existingPets = try modelContext.fetch(descriptor)

        for pet in existingPets {
            modelContext.delete(pet)
        }

        for pet in pets {
            guard pet.id != nil else { continue }
            modelContext.insert(CachedPet(pet: pet))
        }

        try modelContext.save()
    }

    func updateGameScore(_ gameScore: Int, for petId: String) throws {
        guard let pet = try fetchPet(id: petId) else { return }
        pet.gameScore = gameScore
        try modelContext.save()
    }
    
    func updateLastActivity(_ lastActivity: PetLastActivity, for petId: String) throws {
        var descriptor = FetchDescriptor<CachedPet>(
            predicate: #Predicate { $0.id == petId }
        )
        descriptor.fetchLimit = 1

        guard let pet = try modelContext.fetch(descriptor).first else { return }

        pet.lastActivityId = lastActivity.id
        pet.lastActivityType = lastActivity.type
        pet.lastActivityDate = lastActivity.date

        try modelContext.save()
    }

    private func fetchPet(id: String) throws -> CachedPet? {
        var descriptor = FetchDescriptor<CachedPet>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
