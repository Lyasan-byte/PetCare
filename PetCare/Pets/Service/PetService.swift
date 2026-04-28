//
//  PetService.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import FirebaseFirestore
import Combine

final class PetService: PetRepository {
    private let cache: PetCacheRepository
    private let imageService: ImageUploader
    private let firestore: Firestore

    private let petCollection = "pets"

    init(
        firestore: Firestore = .firestore(),
        cache: PetCacheRepository,
        imageService: ImageUploader
    ) {
        self.firestore = firestore
        self.cache = cache
        self.imageService = imageService
    }

    func makeNewPetId() -> String {
        firestore.collection(petCollection).document().documentID
    }

    func save(pet: Pet, petId: String, selectedPhoto: Data?) -> AnyPublisher<Pet, Error> {
        guard let selectedPhoto else {
            return savePet(pet, petId: petId)
        }

        return imageService
            .uploadImage(
                data: selectedPhoto,
                resource: UploadImageResource.pet(id: petId)
            )
            .flatMap { [weak self] url -> AnyPublisher<Pet, Error> in
                guard let self else {
                    return Fail(error: RepositoryError.deallocated).eraseToAnyPublisher()
                }

                var updatedPet = pet
                updatedPet.photoUrl = url.absoluteString
                return self.savePet(updatedPet, petId: petId)
            }
            .eraseToAnyPublisher()
    }

    private func savePet(_ pet: Pet, petId: String) -> AnyPublisher<Pet, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(RepositoryError.deallocated))
                return
            }

            do {
                try self.firestore.collection(petCollection)
                    .document(petId)
                    .setData(from: pet, merge: true) { error in
                        if let error {
                            promise(.failure(error))
                            return
                        }

                        var savedPet = pet
                        savedPet.id = petId

                        do {
                            try self.cache.save(savedPet)
                        } catch {
                            print("Failed to cache saved pet: \(error.localizedDescription)")
                        }

                        promise(.success(savedPet))
                    }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func delete(petId: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(RepositoryError.deallocated))
                return
            }

            self.firestore
                .collection(petCollection)
                .document(petId)
                .delete { error in
                    if let error {
                        promise(.failure(error))
                        return
                    }

                    do {
                        try self.cache.deletePet(id: petId)
                    } catch {
                        print("Failed to delete cached pet: \(error.localizedDescription)")
                    }

                    promise(.success(()))
                }
        }
        .eraseToAnyPublisher()
    }

    func fetchPets(for ownerId: String) -> AnyPublisher<[Pet], Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(RepositoryError.deallocated))
                return
            }

            do {
                let cachedPets = try self.cache.getPets(for: ownerId)
                if !cachedPets.isEmpty {
                    promise(.success(cachedPets))
                    return
                }
            } catch {
                print("Failed to load pets from cache: \(error.localizedDescription)")
            }

            self.firestore.collection(self.petCollection)
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

                        do {
                            try self.cache.replacePets(pets, for: ownerId)
                        } catch {
                            print("Failed to refresh pets cache: \(error.localizedDescription)")
                        }

                        promise(.success(pets))
                    } catch {
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    func updateGameScore(_ gameScore: Int, for petId: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(RepositoryError.deallocated))
                return
            }

            self.firestore.collection(petCollection)
                .document(petId)
                .updateData([
                    Pet.CodingKeys.gameScore.rawValue: gameScore
                ]) { error in
                    if let error {
                        promise(.failure(error))
                        return
                    }

                    do {
                        try self.cache.updateGameScore(gameScore, for: petId)
                    } catch {
                        print("Failed to update cached game score: \(error.localizedDescription)")
                    }

                    promise(.success(()))
                }
        }
        .eraseToAnyPublisher()
    }
}
