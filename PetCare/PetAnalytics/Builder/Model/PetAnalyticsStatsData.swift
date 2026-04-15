//
//  PetAnalyticsStatsData.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

struct PetAnalyticsStatsData: Identifiable, Hashable, Sendable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let style: PetAnalyticsStatsStyle
}
