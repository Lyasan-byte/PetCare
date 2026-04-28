//
//  DeepLTranslationService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.04.2026.
//

import Foundation
import Combine

final class DeepLTranslationService: TranslationRepository {
    private struct TranslationRequestBody: Encodable {
        let text: [String]
        let sourceLang: String
        let targetLang: String

        enum CodingKeys: String, CodingKey {
            case text
            case sourceLang = "source_lang"
            case targetLang = "target_lang"
        }
    }

    private struct TranslationResponse: Decodable {
        let translations: [TranslationItem]
    }

    private struct TranslationItem: Decodable {
        let text: String
    }

    private let urlSession: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let maxRequestBodySize = 128 * 1024
    private let maxTextsPerRequest = 50

    init(
        urlSession: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.encoder = encoder
        self.decoder = decoder
    }

    func translate(
        _ texts: [String],
        from sourceLanguage: SettingsLanguage,
        to targetLanguage: SettingsLanguage
    ) -> AnyPublisher<[String], Error> {
        guard sourceLanguage != targetLanguage else {
            return Just(texts)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        guard !texts.isEmpty else {
            return Just<[String]>([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        guard let baseURL = DeepLConfig.baseURL else {
            return Fail(error: DeepLTranslationServiceError.invalidBaseURL).eraseToAnyPublisher()
        }

        guard let apiKey = DeepLConfig.apiKey else {
            return Fail(error: DeepLTranslationServiceError.missingAPIKey).eraseToAnyPublisher()
        }

        let sourceLanguageCode = sourceLanguage.deepLLanguageCode
        let targetLanguageCode = targetLanguage.deepLLanguageCode
        let chunks = makeTextChunks(
            for: texts,
            sourceLanguageCode: sourceLanguageCode,
            targetLanguageCode: targetLanguageCode
        )

        return chunks.publisher
            .setFailureType(to: Error.self)
            .flatMap(maxPublishers: .max(1)) { [weak self] chunk -> AnyPublisher<[String], Error> in
                guard let self else {
                    return Fail<[String], Error>(
                        error: DeepLTranslationServiceError.serviceDeallocated
                    )
                    .eraseToAnyPublisher()
                }

                return self.translateChunk(
                    chunk,
                    baseURL: baseURL,
                    apiKey: apiKey,
                    sourceLanguageCode: sourceLanguageCode,
                    targetLanguageCode: targetLanguageCode
                )
            }
            .collect()
            .map { $0.flatMap { $0 } }
            .eraseToAnyPublisher()
    }

    private func translateChunk(
        _ texts: [String],
        baseURL: URL,
        apiKey: String,
        sourceLanguageCode: String,
        targetLanguageCode: String
    ) -> AnyPublisher<[String], Error> {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(DeepLConfig.translatePath),
            resolvingAgainstBaseURL: false
        ) else {
            return Fail(error: DeepLTranslationServiceError.invalidBaseURL).eraseToAnyPublisher()
        }

        components.queryItems = []

        guard let url = components.url else {
            return Fail(error: DeepLTranslationServiceError.invalidURL).eraseToAnyPublisher()
        }

        let requestBody = TranslationRequestBody(
            text: texts,
            sourceLang: sourceLanguageCode,
            targetLang: targetLanguageCode
        )

        guard let body = try? encoder.encode(requestBody) else {
            return Fail(error: DeepLTranslationServiceError.invalidRequestBody).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    throw DeepLTranslationServiceError.invalidResponse
                }

                return output.data
            }
            .decode(type: TranslationResponse.self, decoder: decoder)
            .tryMap { response in
                let translatedTexts = response.translations.map(\.text)

                guard translatedTexts.count == texts.count else {
                    throw DeepLTranslationServiceError.unexpectedTranslationCount
                }

                return translatedTexts
            }
            .eraseToAnyPublisher()
    }

    private func makeTextChunks(
        for texts: [String],
        sourceLanguageCode: String,
        targetLanguageCode: String
    ) -> [[String]] {
        var result: [[String]] = []
        var currentChunk: [String] = []

        for text in texts {
            let candidateChunk = currentChunk + [text]
            let exceedsTextLimit = candidateChunk.count > maxTextsPerRequest
            let exceedsBodyLimit = estimatedRequestBodySize(
                for: candidateChunk,
                sourceLanguageCode: sourceLanguageCode,
                targetLanguageCode: targetLanguageCode
            ) > maxRequestBodySize

            if !currentChunk.isEmpty && (exceedsTextLimit || exceedsBodyLimit) {
                result.append(currentChunk)
                currentChunk = []
            }

            currentChunk.append(text)
        }

        if !currentChunk.isEmpty {
            result.append(currentChunk)
        }

        return result
    }

    private func estimatedRequestBodySize(
        for texts: [String],
        sourceLanguageCode: String,
        targetLanguageCode: String
    ) -> Int {
        let requestBody = TranslationRequestBody(
            text: texts,
            sourceLang: sourceLanguageCode,
            targetLang: targetLanguageCode
        )

        return (try? encoder.encode(requestBody).count) ?? .max
    }
}

private extension SettingsLanguage {
    var deepLLanguageCode: String {
        switch self {
        case .english:
            "EN"
        case .russian:
            "RU"
        }
    }
}
