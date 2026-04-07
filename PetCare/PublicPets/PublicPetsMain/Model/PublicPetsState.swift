//
//  PublicPetsState.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import Foundation

struct PublicPetsState {
    var pets: [Pet] = []
    var isLoading: Bool = false
    var hasMore: Bool = true
    var isLoadingMore: Bool = false
    var errorMessage: String?
}
