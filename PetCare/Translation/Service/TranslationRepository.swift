//
//  TranslationRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.04.2026.
//

import Foundation
import Combine

protocol TranslationRepository {
    func translate(
        _ texts: [String],
        from sourceLanguage: SettingsLanguage,
        to targetLanguage: SettingsLanguage
    ) -> AnyPublisher<[String], Error>
}
