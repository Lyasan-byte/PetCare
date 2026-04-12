//
//  PetAnalyticsStatsData.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

struct PetAnalyticsStatsData: Hashable, Sendable {
    let title: String
    let value: String
    let style: PetAnalyticsStatsStyle
}
