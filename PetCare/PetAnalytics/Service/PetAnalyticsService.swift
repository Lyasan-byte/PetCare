//
//  PetAnalyticsService.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Combine
import FirebaseFirestore
import Foundation

final class PetAnalyticsService: PetAnalyticsRepository {
    private let firestore: Firestore
    
    init(firestore: Firestore = .firestore()) {
        self.firestore = firestore
    }
    
    func fetchActivities(
        for petId: String,
        startDate: Date,
        endDate: Date
    ) -> AnyPublisher<[PetActivity], Error> {
        Future { [weak self] promise in
            guard let self else { return }
            
            firestore.collection("activities")
                .whereField(PetActivity.CodingKeys.petId.rawValue, isEqualTo: petId)
                .whereField(PetActivity.CodingKeys.date.rawValue, isGreaterThanOrEqualTo: startDate)
                .whereField(PetActivity.CodingKeys.date.rawValue, isLessThan: endDate)
                .order(by: PetActivity.CodingKeys.date.rawValue)
                .getDocuments { snapshot, error in
                    if let error {
                        return promise(.failure(error))
                    }
                    
                    guard let snapshot else {
                        return promise(.success([]))
                    }
                    
                    do {
                        let activities = try snapshot.documents.map {
                            try $0.data(as: PetActivity.self)
                        }
                        return promise(.success(activities))
                    } catch {
                        return promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
