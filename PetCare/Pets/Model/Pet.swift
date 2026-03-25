//
//  Pet.swift
//  PetCare
//
//  Created by Ляйсан on 25/3/26.
//

import Foundation
import UIKit

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

enum PetIconStatus {
    case heart
    case sparkle
    case star
    
    var iconColor: UIColor {
        switch self {
        case .heart:
            Asset.petPink.color
        case .sparkle:
            Asset.petPurple.color
        case .star:
            Asset.petPink.color
        }
    }
}

struct Pet {
    let id: String
    var name: String
    var breed: String
    var weight: Double
    var dateOfBirth: Date
    var gender: String = Gender.male.rawValue
    var photoUrl: String?
    var ownerId: String
    var isPublic: Bool = false
    var gameScore: Int = 0
    var iconStatus: String
    
    
    
    
    
}
