//
//  LocalizedPetFactsService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.04.2026.
//

import Foundation
import Combine

final class LocalizedPetFactsService: PetFactsRepository {
    private enum TranslationField {
        case name
        case location(Int)
        case diet
        case commonName
        case skinType
        case group
        case slogan
        case lifespan
        case temperament
        case weight
    }

    private let petFactsRepository: PetFactsRepository
    private let translationRepository: TranslationRepository
    private let settingsRepository: SettingsRepository

    init(
        petFactsRepository: PetFactsRepository,
        translationRepository: TranslationRepository,
        settingsRepository: SettingsRepository
    ) {
        self.petFactsRepository = petFactsRepository
        self.translationRepository = translationRepository
        self.settingsRepository = settingsRepository
    }

    func fetcFact(for breed: String) -> AnyPublisher<PetFact?, Error> {
        let language = settingsRepository.loadSettings().language

        return petFactsRepository.fetcFact(for: breed)
            .flatMap { [translationRepository] petFact in
                guard let petFact else {
                    return Just<PetFact?>(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                guard language != .english else {
                    return Just(petFact)
                        .setFailureType(to: Error.self)
                        .map(Optional.some)
                        .eraseToAnyPublisher()
                }

                let payload = Self.makeTranslationPayload(for: petFact)

                guard !payload.texts.isEmpty else {
                    return Just(petFact)
                        .setFailureType(to: Error.self)
                        .map(Optional.some)
                        .eraseToAnyPublisher()
                }

                return translationRepository
                    .translate(payload.texts, from: .english, to: language)
                    .map { translatedTexts in
                        Self.makeTranslatedPetFact(
                            from: petFact,
                            translatedTexts: translatedTexts,
                            fields: payload.fields
                        )
                    }
                    .map(Optional.some)
                    .catch { error in
                        print("LocalizedPetFactsService translation error: \(error.localizedDescription)")
                        return Just(petFact)
                            .setFailureType(to: Error.self)
                            .map(Optional.some)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private static func makeTranslationPayload(for petFact: PetFact) -> (texts: [String], fields: [TranslationField]) {
        var texts: [String] = []
        var fields: [TranslationField] = []

        append(petFact.name, field: .name, texts: &texts, fields: &fields)

        for (index, location) in petFact.locations.enumerated() {
            append(location, field: .location(index), texts: &texts, fields: &fields)
        }

        append(petFact.diet, field: .diet, texts: &texts, fields: &fields)
        append(petFact.commonName, field: .commonName, texts: &texts, fields: &fields)
        append(petFact.skinType, field: .skinType, texts: &texts, fields: &fields)
        append(petFact.group, field: .group, texts: &texts, fields: &fields)
        append(petFact.slogan, field: .slogan, texts: &texts, fields: &fields)
        append(petFact.lifespan, field: .lifespan, texts: &texts, fields: &fields)
        append(petFact.temperament, field: .temperament, texts: &texts, fields: &fields)
        append(petFact.weight, field: .weight, texts: &texts, fields: &fields)

        return (texts, fields)
    }

    private static func append(
        _ value: String?,
        field: TranslationField,
        texts: inout [String],
        fields: inout [TranslationField]
    ) {
        guard let value else { return }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else { return }

        texts.append(trimmedValue)
        fields.append(field)
    }

    private static func makeTranslatedPetFact(
        from petFact: PetFact,
        translatedTexts: [String],
        fields: [TranslationField]
    ) -> PetFact {
        var name = petFact.name
        var locations = petFact.locations
        var diet = petFact.diet
        var commonName = petFact.commonName
        var skinType = petFact.skinType
        var group = petFact.group
        var slogan = petFact.slogan
        var lifespan = petFact.lifespan
        var temperament = petFact.temperament
        var weight = petFact.weight

        for (field, translatedText) in zip(fields, translatedTexts) {
            switch field {
            case .name:
                name = translatedText
            case .location(let index):
                guard locations.indices.contains(index) else { continue }
                locations[index] = translatedText
            case .diet:
                diet = translatedText
            case .commonName:
                commonName = translatedText
            case .skinType:
                skinType = translatedText
            case .group:
                group = translatedText
            case .slogan:
                slogan = translatedText
            case .lifespan:
                lifespan = translatedText
            case .temperament:
                temperament = translatedText
            case .weight:
                weight = translatedText
            }
        }

        return PetFact(
            name: name,
            locations: locations,
            diet: diet,
            commonName: commonName,
            skinType: skinType,
            group: group,
            slogan: slogan,
            lifespan: lifespan,
            temperament: temperament,
            weight: weight
        )
    }
}
