//
//  CachedTip.swift
//  PetCare
//
//  Created by Ляйсан on 4/5/26.
//

import SwiftData
import Foundation

@Model
final class CachedTip {
    @Attribute(.unique)
    var id: String
    
    var cachedAt: Date
    var text: String
    
    init(id: String, cachedAt: Date = Date(), text: String) {
        self.id = id
        self.cachedAt = cachedAt
        self.text = text
    }
    
    convenience init(tip: Tip) {
        self.init(
            id: tip.id ?? UUID().uuidString,
            cachedAt: Date(),
            text: tip.text
        )
    }
    
    func toDomain() -> Tip {
        Tip(id: id, text: text)
    }
}
