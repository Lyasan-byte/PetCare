//
//  LocalizedTipService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.04.2026.
//

import Foundation
import Combine

final class LocalizedTipService: TipRepository {
    private let tipRepository: TipRepository
    private let translationRepository: TranslationRepository
    private let settingsRepository: SettingsRepository

    init(
        tipRepository: TipRepository,
        translationRepository: TranslationRepository,
        settingsRepository: SettingsRepository
    ) {
        self.tipRepository = tipRepository
        self.translationRepository = translationRepository
        self.settingsRepository = settingsRepository
    }

    func fetchTips() -> AnyPublisher<[Tip], Error> {
        let language = settingsRepository.loadSettings().language

        return tipRepository.fetchTips()
            .flatMap { [translationRepository] tips in
                guard language != .english else {
                    return Just(tips)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                return translationRepository
                    .translate(tips.map(\.text), from: .english, to: language)
                    .map { translatedTexts in
                        zip(tips, translatedTexts).map { tip, translatedText in
                            Tip(id: tip.id, text: translatedText)
                        }
                    }
                    .catch { error in
                        print("LocalizedTipService translation error: \(error.localizedDescription)")
                        return Just(tips).setFailureType(to: Error.self)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
