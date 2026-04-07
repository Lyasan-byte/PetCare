//
//  PublicPetsPage.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation
import FirebaseFirestore

struct PublicPetsPage {
    var pets: [Pet] = []
    var lastDocument: DocumentSnapshot?
    var hasMore: Bool
}
