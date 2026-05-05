//
//  TipCacheRepository.swift
//  PetCare
//
//  Created by Ляйсан on 4/5/26.
//

import Foundation

protocol TipCacheRepository {
    func save(tips: [Tip]) throws
    func getTips() throws -> [Tip]
}
