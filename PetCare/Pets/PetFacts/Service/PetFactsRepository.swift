//
//  PetFactsRepository.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation
import Combine

protocol PetFactsRepository {
    func fetcFact(for breed: String) -> AnyPublisher<PetFact?, Error>
}
