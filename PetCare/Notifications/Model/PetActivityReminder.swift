//
//  PetActivityReminder.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13.04.2026.
//

import Foundation

struct PetActivityReminder: Codable, Equatable {
    let activityId: String
    let ownerId: String
    let petId: String
    let petName: String
    let activityType: PetActivityType
    let date: Date
}

extension PetActivityReminder {
    var notificationIdentifier: String {
        "petcare.activity.reminder.\(ownerId).\(petId).\(activityType.rawValue)"
    }
}
