//
//  PublicPetsModuleOutput.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Foundation

protocol PublicPetsModuleOutput: AnyObject {
    func moduleWantsToOpenPetProfile(_ pet: Pet)
}
