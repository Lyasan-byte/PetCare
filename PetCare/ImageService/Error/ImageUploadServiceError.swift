//
//  ImageUploadServiceError.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

enum ImageUploadServiceError: LocalizedError {
    case invalidUploadResponse
    case missingSecureURL
    case invalidSecureURL(String)

    var errorDescription: String? {
        switch self {
        case .invalidUploadResponse:
            return "Upload failed: invalid response from image service."
        case .missingSecureURL:
            return "Upload failed: image URL is missing in the response."
        case .invalidSecureURL(let urlString):
            return "Upload failed: invalid uploaded image URL: \(urlString)"
        }
    }
}
