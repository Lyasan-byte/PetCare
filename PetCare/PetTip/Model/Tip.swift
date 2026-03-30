//
//  Tip.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation
import FirebaseFirestore

struct Tip: Identifiable, Codable {
    @DocumentID var id: String?
    let text: String
}

extension Tip {
    static let defaultTip = "Movement is medicine! Daily walks and playtime prevent boredom, reduce destructive behavior, and keep your pet’s body and mind sharp."
}
