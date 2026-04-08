//
//  PublicPetsState.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Foundation

typealias PublicPetsState = ViewState<PublicPetsContent>

struct PublicPetsContent {
    var pets: [Pet] = []
    var hasMore: Bool = true
}
