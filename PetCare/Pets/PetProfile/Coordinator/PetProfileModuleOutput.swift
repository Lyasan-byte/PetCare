//
//  PetProfileModuleOutput.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

protocol PetProfileModuleOutput: AnyObject {
    func petProfileModuleDidRequestEdit(_ pet: Pet)
    func petProfileModuleDidRequestAnalytics(_ pet: Pet)
    func petProfileModuleDidRequestAddActivity(_ pet: Pet)
    func petProfileModuleDidClose()
}
