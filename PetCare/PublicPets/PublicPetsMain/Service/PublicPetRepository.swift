//
//  PublicPetRepository.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation
import Combine
import FirebaseFirestore

protocol PublicPetRepository {
    func fetch(
        after document: DocumentSnapshot?,
        pageSize: Int,
        sort: PublicPetsSort
    ) -> AnyPublisher<PublicPetsPage, Error>
}
