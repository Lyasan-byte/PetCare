//
//  SettingsViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

protocol SettingsViewModeling: UIKitViewModel where State == SettingsState, Intent == SettingsIntent {}
