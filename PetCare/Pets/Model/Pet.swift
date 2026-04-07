//
//  Pet.swift
//  PetCare
//
//  Created by Ляйсан on 25/3/26.
//

import UIKit
import FirebaseFirestore

struct Pet: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var breed: String
    var weight: Double
    var dateOfBirth: Date
    var gender: Gender
    var note: String
    var photoUrl: String?
    var ownerId: String
    var isPublic: Bool
    var gameScore: Int
    var iconStatus: PetIconStatus

    init(
        id: String?,
        name: String,
        breed: String,
        weight: Double,
        dateOfBirth: Date,
        gender: Gender = .male,
        note: String = "",
        photoUrl: String?,
        ownerId: String,
        isPublic: Bool = false,
        gameScore: Int = 0,
        iconStatus: PetIconStatus = .heart
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.weight = weight
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.note = note
        self.photoUrl = photoUrl
        self.ownerId = ownerId
        self.isPublic = isPublic
        self.gameScore = gameScore
        self.iconStatus = iconStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case breed = "breed"
        case weight = "weight"
        case dateOfBirth = "date_of_birth"
        case gender = "gender"
        case note = "note"
        case photoUrl = "photo_url"
        case ownerId = "owner_id"
        case isPublic = "is_public"
        case gameScore = "game_score"
        case iconStatus = "icon_status"
    }
}

extension Pet {
    var ageText: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: dateOfBirth, to: Date())

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year" : "\(years) years"
        }

        let months = max(components.month ?? 0, 0)
        return months == 1 ? "1 month" : "\(months) months"
    }
}
