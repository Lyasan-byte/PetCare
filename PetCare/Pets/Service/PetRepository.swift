//
//  PetRepository.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Foundation
import Combine

protocol PetRepository {
    func makeNewPetId() -> String
    func save(pet: Pet, petId: String, selectedPhoto: Data?) -> AnyPublisher<Pet, Error>
    func delete(petId: String) -> AnyPublisher<Void, Error>
    func fetchPets(for ownerId: String) -> AnyPublisher<[Pet], Error>
    func updateGameScore(_ gameScore: Int, for petId: String) -> AnyPublisher<Void, Error>
}
