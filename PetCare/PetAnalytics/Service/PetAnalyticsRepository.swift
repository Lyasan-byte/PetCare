//
//  PetAnalyticsRepository.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Combine
import Foundation

protocol PetAnalyticsRepository {
    func fetchActivities(
        for petId: String,
        startDate: Date,
        endDate: Date
    ) -> AnyPublisher<[PetActivity], Error>
}
