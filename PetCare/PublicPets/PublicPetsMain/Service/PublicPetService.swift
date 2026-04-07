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
    private let collection = Firestore.firestore().collection("pets")
    
    func fetch(after document: DocumentSnapshot?, pageSize: Int) -> AnyPublisher<PublicPetsPage, any Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(RepositoryError.deallocated))
                return
            }
            var query = self.baseQuery(pageSize)
            
            if let document {
                query = query.start(afterDocument: document)
            }
            
            query.getDocuments { snapshot, error in
                if let error {
                    promise(.failure(error))
                    return
                }
                
                guard let snapshot else {
                    promise(.success(PublicPetsPage(hasMore: false)))
                    return
                }
                do {
                    let pets = try snapshot.documents.map { try $0.data(as: Pet.self) }
                    let lastDocument = snapshot.documents.last
                    let hasMore = snapshot.documents.count == pageSize
                    
                    promise(.success(.init(pets: pets, lastDocument: lastDocument, hasMore: hasMore)))
                    return
                } catch {
                    promise(.failure(error))
                    return
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func baseQuery(_ size: Int) -> Query {
        collection
            .whereField(Pet.CodingKeys.isPublic.rawValue, isEqualTo: true)
            .order(by: Pet.CodingKeys.gameScore.rawValue, descending: true)
            .limit(to: size)
    }
}
