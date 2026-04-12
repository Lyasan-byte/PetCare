//
//  PetAnalyticsItem.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

enum PetAnalyticsItem: Hashable, Sendable {    
    case header(PetAnalyticsHeaderData)
    case walkChart(BarChartData)
    case goal(GoalCompletionData)
    case costChart(BarChartData)
    case stats(PetAnalyticsStatsData)
    case historyHeader
    case history(PetAnalyticsHistoryData)
}
