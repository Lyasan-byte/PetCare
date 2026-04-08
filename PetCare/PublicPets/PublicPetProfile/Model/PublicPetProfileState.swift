//
//  PublicPetProfileState.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation

typealias PublicPetProfileState = ViewState<PublicPetProfileContent>

struct PublicPetProfileContent {
    var pet: Pet
    var user: UserProfileUser

    init(pet: Pet) {
        self.pet = pet
        self.user = UserProfileUser(
            id: "",
            firstName: "",
            lastName: "",
            email: nil,
            avatarURLString: nil
        )
    }
}
