//
//  PetAnalyticsPeriod.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Foundation

enum PetAnalyticsPeriod: Int, CaseIterable {
    case week
    case month
    case threeMonths
    case year
    
    var title: String {
        switch self {
        case .week:
            return L10n.PetAnalytics.Period.week
        case .month:
            return L10n.PetAnalytics.Period.month
        case .threeMonths:
            return L10n.PetAnalytics.Period.threeMonths
        case .year:
            return L10n.PetAnalytics.Period.year
        }
    }
    
    var chartSubtitle: String {
        switch self {
        case .week:
            return L10n.PetAnalytics.ChartSubtitle.week
        case .month:
            return L10n.PetAnalytics.ChartSubtitle.month
        case .threeMonths:
            return L10n.PetAnalytics.ChartSubtitle.threeMonths
        case .year:
            return L10n.PetAnalytics.ChartSubtitle.year
        }
    }
}

extension PetAnalyticsPeriod {
    func dateRange(relativeTo date: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date)) ?? date

        switch self {
        case .week:
            let start = calendar.date(byAdding: .day, value: -7, to: endOfDay) ?? endOfDay
            return (start, endOfDay)

        case .month:
            let start = calendar.date(byAdding: .day, value: -30, to: endOfDay) ?? endOfDay
            return (start, endOfDay)

        case .threeMonths:
            let start = calendar.date(byAdding: .month, value: -3, to: endOfDay) ?? endOfDay
            return (start, endOfDay)

        case .year:
            let start = calendar.date(byAdding: .year, value: -1, to: endOfDay) ?? endOfDay
            return (start, endOfDay)
        }
    }
}
