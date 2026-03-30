//
//  PetIconStatus.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

enum PetIconStatus: String, Codable, CaseIterable {
    case heart
    case sparkle
    case star
}

extension PetIconStatus {
    var icon: String {
        switch self {
        case .heart:
            "heart.fill"
        case .sparkle:
           "sparkles"
        case .star:
            "star.fill"
        }
    }
    
    var iconColor: UIColor {
        switch self {
        case .heart:
            Asset.accentColor.color
        case .sparkle:
            Asset.purpleAccent.color
        case .star:
            Asset.pinkAccent.color
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .heart:
            Asset.petGreen.color
        case .sparkle:
            Asset.petPurple.color
        case .star:
            Asset.petPink.color
        }
    }
}
