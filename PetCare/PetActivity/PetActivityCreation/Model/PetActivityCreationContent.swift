//
//  PetActivityCreationState.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation

typealias PetActivityCreationState = ViewState<PetActivityCreationContent>

struct PetActivityCreationContent {
    var pets: [Pet] = []
    var selectedPet: Pet?
    var activityId: String
    var activity: PetActivityType = .walk
    var date: Date = Date()
    var note: String = ""
    var isNotificationsOn: Bool = false

    var walkGoal: Double?
    var walkActual: Double?

    var groomingProcedureType: GroomingProcedureType?
    var groomingCost: Double?

    var vetProcedureType: VetProcedureType?
    var vetCost: Double?
}
