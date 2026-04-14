//
//  ActivitiesHistoryBuilding.swift
//  PetCare
//
//  Created by Ляйсан on 14/4/26.
//

import Foundation

protocol ActivitiesHistoryBuilding {
    func buildHistoryData(from activities: [PetActivity]) -> [PetAnalyticsHistoryData]
}
