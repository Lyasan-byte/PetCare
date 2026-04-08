//
//  PetFormIntent.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Foundation

enum PetFormIntent {
    case onChangeName(String)
    case onChangeBreed(String)
    case onChangeWeight(String)
    case onChangeDate(Date)
    case onChangeGender(Gender)
    case onChangeNote(String)
    case onChangeIconStatus(PetIconStatus)
    case onChangeIsPublicProfile(Bool)

    case onPickPhoto(Data?)

    case onSave
    case onDelete
    case onConfirmDelete
    case onDismissAlert
    case onCloseTap
}
