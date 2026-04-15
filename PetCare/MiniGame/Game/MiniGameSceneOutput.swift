//
//  MiniGameSceneOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 12/04/26.
//

import Foundation

protocol MiniGameSceneOutput: AnyObject {
    func miniGameSceneDidUpdateScore(_ score: Int)
    func miniGameSceneDidEndGame(score: Int)
}
