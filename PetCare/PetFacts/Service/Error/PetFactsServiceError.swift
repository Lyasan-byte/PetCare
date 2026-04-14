//
//  PetFactsServiceError.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation

enum PetFactsServiceError: LocalizedError {
    case invalidURL
    case invalidBaseURL
    case missingAPIKey
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response"
        case .invalidURL:
            return "Invalid URL"
        case .invalidBaseURL:
            return "Invalid base URL."
        case .missingAPIKey:
            return "Missing API key."
        }
    }
}
