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
    case onPreviewFinished
    case onRestartTap
    case onDismissAlert
}
