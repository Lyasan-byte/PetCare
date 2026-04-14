//
//  BarChartData.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import Foundation

struct BarChartData: Hashable, Sendable {
    let title: String
    let subtitle: String
    let items: [BarChartItem]
}
