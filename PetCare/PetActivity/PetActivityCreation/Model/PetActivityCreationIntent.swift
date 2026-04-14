//
//  PetActivityCreationIntent.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import Foundation

enum PetActivityCreationIntent {
    case onDidLoad
    case onChangePet(Pet)
    case onChangeActivity(PetActivityType)
    case onChangeDate(Date)
    case onChangeNote(String)
    case onSwitchingNotifications(Bool)

    case onChangeWalkGoal(String)
    case onChangeWalkActual(String)

    case onChangeGroomingProcedureType(GroomingProcedureType)
    case onChangeGroomingCost(String)
    case onChangeGroomingDuration(String)

    case onChangeVetProcedureType(VetProcedureType)
    case onChangeVetCost(String)

    case onDismissAlert
    case onSave
    case onClose
}
