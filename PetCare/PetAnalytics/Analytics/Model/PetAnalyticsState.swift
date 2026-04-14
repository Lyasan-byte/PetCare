//
//  PetAnalyticsState.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Foundation

enum PetAnalyticsState {
    case loading
    case error(String)
    case empty
    case content(PetAnalyticsContent)
}
