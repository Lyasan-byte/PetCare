//
//  GoalCompletionData.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

struct GoalCompletionData: Hashable {
    let goalsCount: Int
    let actualGoalsCompletion: Int
    let description: String
    let progress: CGFloat
}
