//
//  PetAnalyticsState.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Foundation

typealias PetAnalyticsState = ViewState<PetAnalyticsContent>

struct PetAnalyticsContent {
    let pet: Pet
    var selectedPeriod: PetAnalyticsPeriod = .week
    var walkChartItems: BarChartData?
    var spendingsChartItems: BarChartData?
    var goalCompletion: GoalCompletionData?
    var statsData: [PetAnalyticsStatsData] = []
    var historyData: [PetAnalyticsHistoryData] = []
}
