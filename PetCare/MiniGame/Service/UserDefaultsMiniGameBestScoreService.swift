//
//  UserDefaultsMiniGameBestScoreService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Foundation

final class UserDefaultsMiniGameBestScoreService: MiniGameBestScoreRepository {
    private enum Keys {
        static let prefix = "mini.game.bestScore"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func bestScore(for pet: Pet) -> Int {
        max(userDefaults.integer(forKey: storageKey(for: pet)), pet.gameScore)
    }

    func saveBestScore(_ score: Int, for pet: Pet) {
        let key = storageKey(for: pet)
        let persistedScore = userDefaults.integer(forKey: key)
        userDefaults.set(max(max(persistedScore, pet.gameScore), score), forKey: key)
    }

    private func storageKey(for pet: Pet) -> String {
        "\(Keys.prefix).\(pet.miniGameRunnerKey)"
    }
}
