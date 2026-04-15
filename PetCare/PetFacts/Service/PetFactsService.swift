//
//  PetFactsService.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation
import Combine

final class PetFactsService: PetFactsRepository {
    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func fetcFact(for breed: String) -> AnyPublisher<PetFact?, Error> {
        print("DEBUG: \(breed)")
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
            .map { facts in
                return facts.map { $0.toDomain() }.first
            }
            .eraseToAnyPublisher()
    }
}
