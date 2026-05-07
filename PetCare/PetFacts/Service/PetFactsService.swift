//
//  PetFactsService.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation
import Combine

final class PetFactsService: PetFactsRepository {
    private let cache: PetFactsCacheRepository
    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(
        cache: PetFactsCacheRepository,
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.cache = cache
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func fetchFact(for breed: String) -> AnyPublisher<PetFact?, Error> {
        let cacheKey = breed.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        do {
            if let fact = try cache.getFact(for: breed) {
                return Just(fact)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        } catch {
            print("Cache read error:", error)
        }
        
        guard let baseURL = APIConfig.baseURL else {
            return Fail(error: PetFactsServiceError.invalidBaseURL).eraseToAnyPublisher()
        }

        guard let apiKey = APIConfig.apiNinjasKey else {
            return Fail(error: PetFactsServiceError.missingAPIKey).eraseToAnyPublisher()
        }

        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(
                APIConfig.animalsPath
            ), resolvingAgainstBaseURL: false
        ) else {
            return Fail(error: PetFactsServiceError.invalidBaseURL).eraseToAnyPublisher()
        }

        components.queryItems = [URLQueryItem(name: "name", value: breed)]

        guard let url = components.url else {
            return Fail(error: PetFactsServiceError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) else {
                    throw PetFactsServiceError.invalidResponse
                }
                return output.data
            }
            .decode(type: [PetFactDTO].self, decoder: decoder)
            .map { [weak self] facts in
                guard let self else {
                    return nil
                }

                let fact = self.bestMatch(from: facts, for: breed)?.toDomain()

                if let fact {
                    try? self.cache.save(fact: fact, breed: cacheKey)
                }

                return fact
            }
            .eraseToAnyPublisher()
    }
    
    private func bestMatch(from facts: [PetFactDTO], for breed: String) -> PetFactDTO? {
        let query = breed.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !query.isEmpty else {
            return facts.first
        }

        return facts.max {
            matchQuality(for: $0.name, query: query) < matchQuality(for: $1.name, query: query)
        }
    }

    private func matchQuality(for name: String, query: String) -> Int {
        let name = name.lowercased()

        if name == query {
            return 3
        }

        let words = name
            .split { !$0.isLetter && !$0.isNumber }
            .map(String.init)

        if words.contains(query) {
            return 2
        }

        if name.contains(query) {
            return 1
        }

        return 0
    }
}
