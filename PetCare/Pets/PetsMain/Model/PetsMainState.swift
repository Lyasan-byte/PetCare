//
//  PetsMainState.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation

struct PetsMainState {
    var ownerId: String
    var pets: [Pet] = []
    var tips: [Tip] = []
    var tipText: String = Tip.defaultTip
    var isEmptyState: Bool = false
    var isLoading: Bool = false
}
