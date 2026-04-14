//
//  PetAnalyticsStatsStyle.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

enum PetAnalyticsStatsStyle: Hashable, Sendable {
    case walks
    case averageDistance
    case spendings
    
    var icon: String {
        switch self {
        case .walks:
            "figure.walk"
        case .averageDistance:
            "timer"
        case .spendings:
            "wallet.bifold.fill"
        }
    }
}
