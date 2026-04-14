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
            "Week"
        case .month:
            "Month"
        case .threeMonths:
            "3 Months"
        case .year:
            "Year"
        }
    }
    
    var chartSubtitle: String {
        switch self {
        case .week:
            "Last 7 days"
        case .month:
            "Last 30 days"
        case .threeMonths:
            "Last 3 months"
        case .year:
            "Last 12 months"
        }
    }
}

extension PetAnalyticsPeriod {
    func dateRange(relativeTo date: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
        let end = date

        switch self {
        case .week:
            let start = calendar.date(byAdding: .day, value: -7, to: end) ?? end
            return (start, end)

        case .month:
            let start = calendar.date(byAdding: .month, value: -1, to: end) ?? end
            return (start, end)

        case .threeMonths:
            let start = calendar.date(byAdding: .month, value: -3, to: end) ?? end
            return (start, end)

        case .year:
            let start = calendar.date(byAdding: .year, value: -1, to: end) ?? end
            return (start, end)
        }
    }
}
