//
//  ActivitiesHistoryState.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Foundation

typealias ActivitiesHistoryState = ViewState<ActivitiesHistoryContent>

struct ActivitiesHistoryContent {
    let petId: String
    var activities: [PetAnalyticsHistoryData] = []
    var hasMore: Bool = true
}
