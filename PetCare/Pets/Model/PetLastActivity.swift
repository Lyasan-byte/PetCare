//
//  PetLastActivity.swift
//  PetCare
//
//  Created by Ляйсан on 14/4/26.
//

import Foundation

struct PetLastActivity: Codable, Equatable {
    let id: String
    let type: PetActivityType
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, type, date
    }
}
