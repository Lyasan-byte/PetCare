//
//  TipRepository.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation
import Combine

protocol TipRepository {
    func fetchTips() -> AnyPublisher<[Tip], Error>
}
