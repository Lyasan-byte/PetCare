//
//  ActivitiesHistoryBuilder.swift
//  PetCare
//
//  Created by Ляйсан on 14/4/26.
//

import Foundation

final class ActivitiesHistoryBuilder: ActivitiesHistoryBuilding {
    private let dateFormatter: DateFormatter
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.dateFormatter = dateFormatter
    }
    
    func buildHistoryData(from activities: [PetActivity]) -> [PetAnalyticsHistoryData] {
        activities.map { activity in
            PetAnalyticsHistoryData(
                activityType: activity.type,
                date: dateFormatter.string(from: activity.date),
                activityDetail: makeHistoryDetail(for: activity)
            )
        }
    }
    
    private func makeHistoryDetail(for activity: PetActivity) -> String {
        switch activity.details {
        case .walk(let details):
            return L10n.PetAnalytics.History.walkDistance(Float(details.actual))

        case .grooming(let details):
            return details.procedureType.title

        case .vet(let details):
            return details.procedureType.title
        }
    }
}
