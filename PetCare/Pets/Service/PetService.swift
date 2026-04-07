//
//  PetService.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import FirebaseFirestore
import Combine

final class PetService: PetRepository {
    private let imageService: ImageUploader
    private let petsCollection = Firestore.firestore().collection("pets")
    
    init(imageService: ImageUploader) {
        self.imageService = imageService
    }
    
    func makeNewPetId() -> String {
        petsCollection.document().documentID
    }
    
    func save(pet: Pet, petId: String, selectedPhoto: Data?) -> AnyPublisher<Pet, Error> {
        guard let selectedPhoto else { return savePet(pet, petId: petId) }
        
        return imageService
            .uploadImage(data: selectedPhoto,
                         resource: UploadImageResource.pet(id: petId))
            .flatMap { [weak self] url -> AnyPublisher<Pet, Error> in
                guard let self else { return Fail(error: RepositoryError.deallocated)
                    .eraseToAnyPublisher() }
                var updatedPet = pet
                updatedPet.photoUrl = url.absoluteString
                return self.savePet(updatedPet, petId: petId)
            }
            .eraseToAnyPublisher()
    }
    
    private func savePet(_ pet: Pet, petId: String) -> AnyPublisher<Pet, Error> {
        Future { [weak self] promise in
            guard let self else {
                return promise(.failure(RepositoryError.deallocated))
            }
            
            do {
                try self.petsCollection.document(petId).setData(from: pet, merge: true) { error in
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
            guard let self else { return promise(.failure(RepositoryError.deallocated)) }
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
            guard let self else { return promise(.failure(RepositoryError.deallocated)) }
            self.petsCollection
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
