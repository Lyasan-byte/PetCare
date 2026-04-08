//
//  PetIconStatus.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

enum PetIconStatus: String, Codable, CaseIterable {
    case none = "NONE"
    case heart = "HEART"
    case sparkles = "SPARKLES"
    case star = "STAR"
}

extension PetIconStatus {
    var icon: String {
        switch self {
        case .none:
            "xmark"
        case .heart:
            "heart.fill"
        case .sparkles:
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
            Asset.primaryGreen.color
        case .sparkles:
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
        case .sparkles:
            Asset.petPurple.color
        case .star:
            Asset.petPink.color
        }
    }
}
