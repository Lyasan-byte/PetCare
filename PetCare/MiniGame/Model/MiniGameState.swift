//
//  MiniGameState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Foundation

enum MiniGameState {
    case loading
    case content(MiniGameContent)
    case error(String)
}

struct MiniGameContent {
    var pets: [Pet] = []
    var selectedPetKey: String?
    var currentScore: Int = 0
    var bestScore: Int = 0
    var lastRunScore: Int = 0
    var stage: MiniGameStage = .idle

    var selectedPet: Pet? {
        guard let selectedPetKey else { return pets.first }
        return pets.first { $0.miniGameRunnerKey == selectedPetKey } ?? pets.first
    }

    var isEmpty: Bool {
        pets.isEmpty
    }
}

enum MiniGameStage {
    case idle
    case started
    case finished
}

extension Pet {
    var miniGameRunnerKey: String {
        if let id, !id.isEmpty {
            return id
        }

        return "\(ownerId)-\(name.lowercased())-\(breed.lowercased())"
    }
}
