//
//  PetActivity.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import Foundation
import FirebaseFirestore

struct PetActivity: Codable {
    @DocumentID var id: String?
    var petId: String
    var date: Date
    var isReminder: Bool
    var note: String
    var type: PetActivityType
    var details: PetActivityDetails

    enum CodingKeys: String, CodingKey {
        case id
        case petId = "pet_id"
        case date
        case isReminder = "is_reminder"
        case note
        case type
        case details
    }

    init(
        id: String? = nil,
        petId: String,
        date: Date,
        isReminder: Bool,
        note: String,
        type: PetActivityType,
        details: PetActivityDetails
    ) {
        self.id = id
        self.petId = petId
        self.date = date
        self.isReminder = isReminder
        self.note = note
        self.type = type
        self.details = details
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        petId = try container.decode(String.self, forKey: .petId)
        date = try container.decode(Date.self, forKey: .date)
        isReminder = try container.decode(Bool.self, forKey: .isReminder)
        note = try container.decode(String.self, forKey: .note)
        type = try container.decode(PetActivityType.self, forKey: .type)

        switch type {
        case .walk:
            let walkDetails = try container.decode(WalkDetails.self, forKey: .details)
            details = .walk(walkDetails)

        case .grooming:
            let groomingDetails = try container.decode(GroomingDetails.self, forKey: .details)
            details = .grooming(groomingDetails)

        case .vet:
            let vetDetails = try container.decode(VetDetails.self, forKey: .details)
            details = .vet(vetDetails)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(petId, forKey: .petId)
        try container.encode(date, forKey: .date)
        try container.encode(isReminder, forKey: .isReminder)
        try container.encode(note, forKey: .note)
        try container.encode(type, forKey: .type)

        switch details {
        case .walk(let walkDetails):
            try container.encode(walkDetails, forKey: .details)

        case .grooming(let groomingDetails):
            try container.encode(groomingDetails, forKey: .details)

        case .vet(let vetDetails):
            try container.encode(vetDetails, forKey: .details)
        }
    }
}

enum PetActivityDetails: Codable {
    case walk(WalkDetails)
    case grooming(GroomingDetails)
    case vet(VetDetails)
}

struct WalkDetails: Codable {
    let goal: Double
    let actual: Double
}

struct GroomingDetails: Codable {
    let procedureType: GroomingProcedureType
    let cost: Double
    let duration: Double

    enum CodingKeys: String, CodingKey {
        case procedureType = "procedure_type"
        case cost
        case duration
    }
}

struct VetDetails: Codable {
    let procedureType: VetProcedureType
    let cost: Double

    enum CodingKeys: String, CodingKey {
        case procedureType = "procedure_type"
        case cost
    }
}
