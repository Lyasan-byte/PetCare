//
//  ActivitiesHistoryPage.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Foundation
import FirebaseFirestore

struct ActivitiesHistoryPage {
    var activities: [PetActivity]
    var lastDocument: DocumentSnapshot?
    var hasMore: Bool
}
