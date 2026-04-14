//
//  ActivitiesHistoryRepository.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Combine
import Foundation
import FirebaseFirestore

protocol ActivitiesHistoryRepository {
    func fetchActivities(for petId: String, after documet: DocumentSnapshot?, pageSize: Int) -> AnyPublisher<ActivitiesHistoryPage, Error>
}
