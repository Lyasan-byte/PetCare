//
//  DeepLTranslationServiceError.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.04.2026.
//

import Foundation

enum DeepLTranslationServiceError: LocalizedError {
    case invalidURL
    case invalidBaseURL
    case missingAPIKey
    case invalidResponse
    case invalidRequestBody
    case unexpectedTranslationCount
    case serviceDeallocated

    var errorDescription: String? {
        switch self {
        case .invalidURL,
             .invalidBaseURL,
             .missingAPIKey,
             .invalidResponse,
             .invalidRequestBody,
             .unexpectedTranslationCount,
             .serviceDeallocated:
            return NSLocalizedString("error.common.try_again", comment: "")
        }
    }
}
