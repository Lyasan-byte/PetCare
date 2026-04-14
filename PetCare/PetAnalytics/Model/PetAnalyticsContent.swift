//
//  PetAnalyticsContent.swift
//  PetCare
//
//  Created by Ляйсан on 11/4/26.
//

import Foundation

struct PetAnalyticsContent {
    let pet: Pet
    var selectedPeriod: PetAnalyticsPeriod = .week
    var analyticsHeaderData: PetAnalyticsHeaderData?
    var walkChartData: BarChartData?
    var spendingsChartData: BarChartData?
    var goalCompletionData: GoalCompletionData?
    var statsData: [PetAnalyticsStatsData] = []
    var historyData: [PetAnalyticsHistoryData] = []
}
