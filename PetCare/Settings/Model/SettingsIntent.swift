//
//  SettingsIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

enum SettingsIntent {
    case backTapped
    case allNotificationsToggled(Bool)
    case groomingToggled(Bool)
    case veterinarianToggled(Bool)
    case generalRemindersToggled(Bool)
}
