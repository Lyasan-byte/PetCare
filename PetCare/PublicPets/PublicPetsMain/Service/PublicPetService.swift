//
//  PublicPetService.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation
import FirebaseFirestore
import Combine

final class PublicPetService: PublicPetRepository {
    private let firestore: Firestore

    init(firestore: Firestore = .firestore()) {
        self.firestore = firestore
    }

    func fetch(
        after document: DocumentSnapshot?,
        pageSize: Int
    ) -> AnyPublisher<PublicPetsPage, Error> {
        var query = baseQuery(pageSize)

        if let document {
            query = query.start(afterDocument: document)
        }

        return query
            .getDocumentsPublisher()
            .map { snapshot in
                let pets = snapshot.documents.compactMap { doc in
                    try? doc.data(as: Pet.self)
                }
                return PublicPetsPage(
                    pets: pets,
                    lastDocument: snapshot.documents.last,
                    hasMore: snapshot.documents.count == pageSize
                )
            }
            .eraseToAnyPublisher()
    }

    private func baseQuery(_ size: Int) -> Query {
        firestore.collection("pets")
            .whereField(Pet.CodingKeys.isPublic.rawValue, isEqualTo: true)
            .order(by: Pet.CodingKeys.gameScore.rawValue, descending: true)
            .limit(to: size)
    }
}

extension Query {
    func getDocumentsPublisher() -> AnyPublisher<QuerySnapshot, Error> {
        Future<QuerySnapshot, Error> { promise in
            self.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                } else {
                    promise(.failure(RepositoryError.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
