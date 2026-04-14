//
//  PetActivityType.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

enum PetActivityType: String, Codable, CaseIterable, Hashable, Sendable {
    case walk = "WALK"
    case grooming = "GROOMING"
    case vet = "VET"

    var name: String {
        switch self {
        case .walk:
            L10n.Pets.Main.QuickActions.walk
        case .grooming:
            L10n.Pets.Main.QuickActions.grooming
        case .vet:
            L10n.Pets.Main.QuickActions.vet
        }
    }

    var icon: String {
        switch self {
        case .walk:
            { if #available(iOS 17.0, *) { return "dog.fill" }; return "figure.walk" }()
        case .grooming:
            "scissors"
        case .vet:
            "cross.case"
        }
    }

    var color: UIColor {
        switch self {
        case .walk:
            Asset.accentColor.color
        case .grooming:
            Asset.purpleAccent.color
        case .vet:
            Asset.pinkAccent.color
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .walk:
            Asset.petGreenAction.color
        case .grooming:
            Asset.petPurpleAction.color
        case .vet:
            Asset.petPinkAction.color
        }
    }
}

extension PetActivityType {
    var activityBackgroundColor: UIColor {
        switch self {
        case .walk:
            Asset.lightGreen.color
        case .grooming:
            Asset.lightPurple.color
        case .vet:
            Asset.lightPink.color
        }
    }
}
