//
//  ActivitiesHistoryService.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Combine
import Foundation
import FirebaseFirestore

final class ActivitiesHistoryService: ActivitiesHistoryRepository {
    private var firestore: Firestore
    
    init(firestore: Firestore = .firestore()) {
        self.firestore = firestore
    }
    
    func fetchActivities(
        for petId: String,
        after document: DocumentSnapshot?,
        pageSize: Int
    ) -> AnyPublisher<ActivitiesHistoryPage, Error> {
        var query = baseQuery(for: petId, pageSize: pageSize)
        
        if let document {
            query.start(afterDocument: document)
        }
        
        return query.getDocumentsPublisher()
            .map { snapshot in
                let activities = snapshot.documents.compactMap { try? $0.data(as: PetActivity.self) }
                
                return ActivitiesHistoryPage(
                    activities: activities,
                    lastDocument: snapshot.documents.last,
                    hasMore: snapshot.documents.count == pageSize
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func baseQuery(for petId: String, pageSize: Int) -> Query {
        firestore.collection("activities")
            .whereField(PetActivity.CodingKeys.petId.rawValue, isEqualTo: petId)
            .order(by: PetActivity.CodingKeys.date.rawValue, descending: true)
            .limit(to: pageSize)
    }
}
