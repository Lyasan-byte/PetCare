//
//  RegisterModuleOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import Foundation

protocol RegisterModuleOutput: AnyObject {
    func tapLogin()
    func moduleWantsToOpenMainScreen()
}
