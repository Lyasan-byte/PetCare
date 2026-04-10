//
//  PetScoreFormatter.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Foundation

enum PetScoreFormatter {
    static func string(for value: Int) -> String {
        let preferredLanguage = Locale.preferredLanguages.first ?? ""

        guard preferredLanguage.hasPrefix("ru") else {
            return L10n.Pets.Public.GameScore.Points.many(value)
        }

        let mod10 = value % 10
        let mod100 = value % 100

        if mod10 == 1 && mod100 != 11 {
            return L10n.Pets.Public.GameScore.Points.one(value)
        } else if (2...4).contains(mod10) && !(12...14).contains(mod100) {
            return L10n.Pets.Public.GameScore.Points.few(value)
        } else {
            return L10n.Pets.Public.GameScore.Points.many(value)
        }
    }
}
