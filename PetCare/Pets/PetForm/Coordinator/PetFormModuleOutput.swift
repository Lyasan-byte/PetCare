//
//  PetFormModuleOutput.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

protocol PetFormModuleOutput: AnyObject {
    func petFormModuleDidSave(_ pet: Pet)
    func petFormModuleDidDelete()
    func petFormModuleDidClose()
}
