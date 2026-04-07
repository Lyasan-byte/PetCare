//
//  PetsMainModuleOutput.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

protocol PetsMainModuleOutput: AnyObject {
    func petsMainModuleDidRequestAddPet()
    func petsMainModuleDidRequestOpenPet(_ pet: Pet)
    func petsMainModuleDidRequestAddActivity(_ activity: PetActivityType)
}
