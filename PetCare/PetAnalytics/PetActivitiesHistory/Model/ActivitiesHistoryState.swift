//
//  ActivitiesHistoryState.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Foundation

enum ActivitiesHistoryState {
    case error(String)
    case empty(String)
    case loading
    case content(ActivitiesHistoryContent)
}

struct ActivitiesHistoryContent {
    let petId: String
    var activities: [PetAnalyticsHistoryData] = []
    var hasMore: Bool = true
    var filterOption: ActivitiesFilter = .all
}
