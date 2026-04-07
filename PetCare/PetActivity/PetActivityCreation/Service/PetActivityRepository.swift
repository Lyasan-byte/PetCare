//
//  PetActivityRepository.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import Foundation
import Combine

protocol PetActivityRepository {
    func makeNewActivityId() -> String
    func save(activity: PetActivity, activityId: String) -> AnyPublisher<Void, Error>
}
