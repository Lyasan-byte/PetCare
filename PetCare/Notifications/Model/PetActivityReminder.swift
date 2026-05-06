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
    let time: Date

    enum CodingKeys: String, CodingKey {
        case activityId
        case ownerId
        case petId
        case petName
        case activityType
        case date
        case time
    }

    init(
        activityId: String,
        ownerId: String,
        petId: String,
        petName: String,
        activityType: PetActivityType,
        date: Date,
        time: Date
    ) {
        self.activityId = activityId
        self.ownerId = ownerId
        self.petId = petId
        self.petName = petName
        self.activityType = activityType
        self.date = date
        self.time = time
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activityId = try container.decode(String.self, forKey: .activityId)
        ownerId = try container.decode(String.self, forKey: .ownerId)
        petId = try container.decode(String.self, forKey: .petId)
        petName = try container.decode(String.self, forKey: .petName)
        activityType = try container.decode(PetActivityType.self, forKey: .activityType)
        date = try container.decode(Date.self, forKey: .date)
        time = try container.decodeIfPresent(Date.self, forKey: .time) ?? Self.defaultTime()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activityId, forKey: .activityId)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(petId, forKey: .petId)
        try container.encode(petName, forKey: .petName)
        try container.encode(activityType, forKey: .activityType)
        try container.encode(date, forKey: .date)
        try container.encode(time, forKey: .time)
    }
}

extension PetActivityReminder {
    static func defaultTime(calendar: Calendar = .current) -> Date {
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        return calendar.date(
            bySettingHour: 9,
            minute: 0,
            second: 0,
            of: startOfDay
        ) ?? now
    }

    var notificationIdentifier: String {
        "petcare.activity.reminder.\(ownerId).\(petId).\(activityType.rawValue)"
    }
}
