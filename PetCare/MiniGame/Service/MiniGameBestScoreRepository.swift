//
//  MiniGameBestScoreRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Foundation

protocol MiniGameBestScoreRepository {
    func bestScore(for pet: Pet) -> Int
    func saveBestScore(_ score: Int, for pet: Pet)
}
