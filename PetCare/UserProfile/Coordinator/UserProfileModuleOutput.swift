//
//  UserProfileModuleOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Foundation

protocol UserProfileModuleOutput: AnyObject {
    func userProfileModuleDidRequestEdit()
    func userProfileModuleDidRequestSettings()
}
