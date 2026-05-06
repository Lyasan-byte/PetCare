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
        pageSize: Int,
        filter: ActivitiesFilter
    ) -> AnyPublisher<ActivitiesHistoryPage, Error> {
        var query = baseQuery(for: petId, pageSize: pageSize, filter: filter)

        if let document {
            query = query.start(afterDocument: document)
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

    private func baseQuery(for petId: String, pageSize: Int, filter: ActivitiesFilter) -> Query {
        var query = firestore.collection("activities")
            .whereField(PetActivity.CodingKeys.petId.rawValue, isEqualTo: petId)

        switch filter {
        case .all:
            break
        case .walk, .grooming, .vet:
            query = query.whereField(
                PetActivity.CodingKeys.type.rawValue,
                isEqualTo: filter.rawValue
            )
        }

        return query
            .order(by: PetActivity.CodingKeys.date.rawValue, descending: true)
            .limit(to: pageSize)
    }
}
