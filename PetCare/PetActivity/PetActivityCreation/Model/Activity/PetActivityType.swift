//
//  PetActivityType.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

enum PetActivityType: String, Codable, CaseIterable {
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

    var reminderSubtitle: String {
        switch self {
        case .walk:
            NSLocalizedString("pets.activity.reminder.daily.subtitle", comment: "")
        case .grooming, .vet:
            NSLocalizedString("pets.activity.reminder.monthly.subtitle", comment: "")
        }
    }

    var notificationTitle: String {
        switch self {
        case .walk:
            NSLocalizedString("notifications.walk.title", comment: "")
        case .grooming:
            NSLocalizedString("notifications.grooming.title", comment: "")
        case .vet:
            NSLocalizedString("notifications.vet.title", comment: "")
        }
    }

    var notificationBodyFormat: String {
        switch self {
        case .walk:
            NSLocalizedString("notifications.walk.body", comment: "")
        case .grooming:
            NSLocalizedString("notifications.grooming.body", comment: "")
        case .vet:
            NSLocalizedString("notifications.vet.body", comment: "")
        }
    }
}
