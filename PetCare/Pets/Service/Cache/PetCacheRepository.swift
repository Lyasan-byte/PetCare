//
//  PetCacheRepository.swift
//  PetCare
//
//  Created by Ляйсан on 15/4/26.
//

import Foundation

protocol PetCacheRepository {
    func save(_ pet: Pet) throws
    func getPets(for ownerId: String) throws -> [Pet]
    func deletePet(id: String) throws
    func replacePets(_ pets: [Pet], for ownerId: String) throws
    func updateGameScore(_ gameScore: Int, for petId: String) throws
    func updateLastActivity(_ lastActivity: PetLastActivity, for petId: String) throws
}
