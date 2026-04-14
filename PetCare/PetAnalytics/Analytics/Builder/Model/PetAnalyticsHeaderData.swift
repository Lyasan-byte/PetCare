//
//  PetAnalyticsHeaderData.swift
//  PetCare
//
//  Created by Ляйсан on 11/4/26.
//

import Foundation

struct PetAnalyticsHeaderData: Hashable, Sendable {
    let petName: String
    let petBreedAndAge: String
    let photoUrl: String?
    var selectedPeriod: PetAnalyticsPeriod
}
