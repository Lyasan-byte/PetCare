//
//  PetService.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import FirebaseFirestore
import Combine

enum PetRepositoryError: LocalizedError {
    case repositoryDeallocated

    var errorDescription: String? {
        switch self {
        case .repositoryDeallocated:
            return "Repository was deallocated"
        }
       
    }
}

final class PetService: PetRepository {
    private let petsCollection = Firestore.firestore().collection("pets")
    
    func makeNewPetId() -> String {
        petsCollection.document().documentID
    }
    
    func save(pet: Pet) -> AnyPublisher<Pet, Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(PetRepositoryError.repositoryDeallocated)) }
            
            do {
                try self.petsCollection.document(pet.id).setData(from: pet, merge: true) { error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        promise(.success(pet))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    func delete(petId: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(PetRepositoryError.repositoryDeallocated)) }
            self.petsCollection.document(petId).delete { error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPets(for ownerId: String) -> AnyPublisher<[Pet], Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(PetRepositoryError.repositoryDeallocated)) }
            petsCollection
                .whereField(Pet.CodingKeys.ownerId.rawValue, isEqualTo: ownerId)
                .getDocuments { snapshot, error in
                    if let error {
                        promise(.failure(error))
                        return
                    }
                    
                    guard let snapshot else {
                        promise(.success([]))
                        return
                    }
                    
                    do {
                        let pets = try snapshot.documents.map { try $0.data(as: Pet.self) }
                        promise(.success(pets))
                    } catch {
                        promise(.failure(error))
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
