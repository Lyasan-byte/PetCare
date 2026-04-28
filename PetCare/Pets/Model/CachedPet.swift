//
//  CachedPet.swift
//  PetCare
//
//  Created by Ляйсан on 15/4/26.
//

import Foundation
import SwiftData

@Model
final class CachedPet {
    @Attribute(.unique)
    var id: String
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

    var lastActivityDate: Date?
    var lastActivityId: String?
    var lastActivityType: PetActivityType?

    init(
        id: String,
        name: String,
        breed: String,
        weight: Double,
        dateOfBirth: Date,
        gender: Gender,
        note: String,
        photoUrl: String?,
        ownerId: String,
        isPublic: Bool,
        gameScore: Int,
        iconStatus: PetIconStatus,
        lastActivityDate: Date?,
        lastActivityId: String?,
        lastActivityType: PetActivityType?
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
        self.lastActivityDate = lastActivityDate
        self.lastActivityId = lastActivityId
        self.lastActivityType = lastActivityType
    }

    convenience init(pet: Pet) {
        self.init(
            id: pet.id ?? UUID().uuidString,
            name: pet.name,
            breed: pet.breed,
            weight: pet.weight,
            dateOfBirth: pet.dateOfBirth,
            gender: pet.gender,
            note: pet.note,
            photoUrl: pet.photoUrl,
            ownerId: pet.ownerId,
            isPublic: pet.isPublic,
            gameScore: pet.gameScore,
            iconStatus: pet.iconStatus,
            lastActivityDate: pet.lastActivity?.date,
            lastActivityId: pet.lastActivity?.id,
            lastActivityType: pet.lastActivity?.type
        )
    }

    func toDomain() -> Pet {
        Pet(
            id: id,
            name: name,
            breed: breed,
            weight: weight,
            dateOfBirth: dateOfBirth,
            gender: gender,
            note: note,
            photoUrl: photoUrl,
            ownerId: ownerId,
            isPublic: isPublic,
            gameScore: gameScore,
            iconStatus: iconStatus,
            lastActivity: makeLastActivity()
        )
    }

    private func makeLastActivity() -> PetLastActivity? {
        guard
            let lastActivityId,
            let lastActivityDate,
            let lastActivityType
        else {
            return nil
        }

        return PetLastActivity(
            id: lastActivityId,
            type: lastActivityType,
            date: lastActivityDate
        )
    }
}
