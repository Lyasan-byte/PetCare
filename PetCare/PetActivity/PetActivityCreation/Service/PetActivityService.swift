//
//  PetActivityService.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import Foundation
import Combine
import FirebaseFirestore

final class PetActivityService: PetActivityRepository {
    private let db: Firestore
    
    init(db: Firestore = .firestore()) {
        self.db = db
    }
    
    func makeNewActivityId() -> String {
        return db.collection("activities").document().documentID
    }
    
    func save(activity: PetActivity, activityId: String) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self else { return }
            
            do {
                try db.collection("activities")
                    .document(activityId)
                    .setData(from: activity) { error in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
