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
    private let firestore: Firestore
    
    private let activities = "activities"
    private let pets = "pets"

    init(firestore: Firestore = .firestore()) {
        self.firestore = firestore
    }

    func makeNewActivityId() -> String {
        return firestore.collection(activities).document().documentID
    }

    func save(activity: PetActivity, activityId: String) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self else { return }

            let activities = firestore.collection(activities).document(activityId)
            let pets = firestore.collection(pets).document(activity.petId)
            
            do {
                try activities.setData(from: activity) { [weak self] error in
                    guard let self else { return }
                    if let error {
                        return promise(.failure(error))
                    }
                    
                    pets.getDocument() { snapshot, error in
                        if let error {
                            return promise(.failure(error))
                        }
                        
                        let lastActivity = snapshot?.data()?[Pet.CodingKeys.lastActivity.rawValue] as? [String:Any]
                        let lastActivityDate = lastActivity?[PetLastActivity.CodingKeys.date.rawValue] as? Date
                        
                        var shouldUpdate = true
                        if let lastActivityDate {
                            shouldUpdate = activity.date > lastActivityDate
                        }
                        
                        guard shouldUpdate else {
                            return promise(.success(()))
                        }
                        
                        let activityToUpdate: [String:Any] = [
                            PetLastActivity.CodingKeys.id.rawValue : activityId,
                            PetLastActivity.CodingKeys.type.rawValue : activity.type.rawValue,
                            PetLastActivity.CodingKeys.date.rawValue : activity.date
                        ]
                        
                        pets.setData([
                            Pet.CodingKeys.lastActivity.rawValue: activityToUpdate
                        ], merge: true) { error in
                            if let error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
