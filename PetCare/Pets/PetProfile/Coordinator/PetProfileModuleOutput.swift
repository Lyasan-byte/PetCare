//
//  PetProfileModuleOutput.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

protocol PetProfileModuleOutput: AnyObject {
    func moduleWantsToOpenEdit(_ pet: Pet)
    func moduleWantsToOpenAnalytics(_ pet: Pet)
    func moduleWantsToOpenBreedFactSheet(_ petFact: PetFact)
    func moduleWantsToClose()
}
