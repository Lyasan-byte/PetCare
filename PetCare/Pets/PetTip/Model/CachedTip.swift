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
    var text: String
    
    init(id: String, text: String) {
        self.id = id
        self.text = text
    }
    
    convenience init(tip: Tip) {
        self.init(
            id: tip.id ?? UUID().uuidString,
            text: tip.text
        )
    }
    
    func toDomain() -> Tip {
        Tip(id: id, text: text)
    }
}
