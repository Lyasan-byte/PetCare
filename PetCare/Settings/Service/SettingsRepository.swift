//
//  SettingsRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

protocol SettingsRepository {
    func loadSettings() -> SettingsState
    func save(settings: SettingsState)
}
