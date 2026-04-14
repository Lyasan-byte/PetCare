//
//  MiniGameIntent.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Foundation

enum MiniGameIntent {
    case onDidLoad
    case onPetSelected(Pet)
    case onGameFieldTap
    case onGameScoreUpdated(Int)
    case onGameEnded(Int)
    case onRestartTap
    case onDismissAlert
}
