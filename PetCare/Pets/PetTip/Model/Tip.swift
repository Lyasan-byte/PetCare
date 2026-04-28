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

    init(id: String? = nil, text: String) {
        self.id = id
        self.text = text
    }
}

extension Tip {
    static let defaultTip = L10n.Pets.Main.Tip.defaultText
}
