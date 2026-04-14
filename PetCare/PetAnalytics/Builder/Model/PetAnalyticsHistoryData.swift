//
//  PetAnalyticsHistoryData.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

struct PetAnalyticsHistoryData: Hashable {
    let activityType: PetActivityType
    let date: String
    let activityDetail: String
}
