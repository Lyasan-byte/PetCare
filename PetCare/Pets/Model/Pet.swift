//
//  Pet.swift
//  PetCare
//
//  Created by Ляйсан on 25/3/26.
//

import FirebaseFirestore
import UIKit

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
        let components = calendar.dateComponents([.year, .month, .day], from: dateOfBirth, to: Date())

        if let years = components.year, years > 0 {
            return localizedPlural(
                value: years,
                one: L10n.Pets.Age.Year.one(years),
                few: L10n.Pets.Age.Year.few(years),
                many: L10n.Pets.Age.Year.many(years)
            )
        }

        if let months = components.month, months > 0 {
            return localizedPlural(
                value: months,
                one: L10n.Pets.Age.Month.one(months),
                few: L10n.Pets.Age.Month.few(months),
                many: L10n.Pets.Age.Month.many(months)
            )
        }

        let days = max(components.day ?? 0, 0)
        return localizedPlural(
            value: days,
            one: L10n.Pets.Age.Day.one(days),
            few: L10n.Pets.Age.Day.few(days),
            many: L10n.Pets.Age.Day.many(days)
        )
    }

    private func localizedPlural(value: Int, one: String, few: String, many: String) -> String {
        let preferredLanguage = Locale.preferredLanguages.first ?? ""

        guard preferredLanguage.hasPrefix("ru") else {
            return value == 1 ? one : many
        }

        let mod10 = value % 10
        let mod100 = value % 100

        if mod10 == 1 && mod100 != 11 {
            return one
        } else if (2...4).contains(mod10) && !(12...14).contains(mod100) {
            return few
        } else {
            return many
        }
    }
}
