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

    init(firestore: Firestore = .firestore()) {
        self.firestore = firestore
    }

    func makeNewActivityId() -> String {
        return firestore.collection("activities").document().documentID
    }

    func save(activity: PetActivity, activityId: String) -> AnyPublisher<Void, any Error> {
        Future { [weak self] promise in
            guard let self else { return }

            do {
                try firestore.collection("activities")
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
