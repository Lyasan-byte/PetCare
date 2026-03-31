//
//  PetIconStatus.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

enum PetIconStatus: String, Codable, CaseIterable {
    case none
    case heart
    case sparkle
    case star
}

extension PetIconStatus {
    var icon: String {
        switch self {
        case .none:
            "xmark"
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
        case .none:
            Asset.redAccent.color
        case .heart:
            Asset.accentColor.color
        case .sparkle:
            Asset.purpleAccentStatus.color
        case .star:
            Asset.pinkAccentStatus.color
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .none:
            Asset.lightRed.color
        case .heart:
            Asset.petGreen.color
        case .sparkle:
            Asset.petPurple.color
        case .star:
            Asset.petPink.color
        }
    }
}
