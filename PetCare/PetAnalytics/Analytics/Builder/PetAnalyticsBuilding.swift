//
//  PetAnalyticsBuilding.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

protocol PetAnalyticsBuilding {
    func buildContent(
        petId: String,
        pet: Pet,
        petActivities: [PetActivity],
        period: PetAnalyticsPeriod
    ) -> PetAnalyticsContent
}
