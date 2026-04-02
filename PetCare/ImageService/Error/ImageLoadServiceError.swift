//
//  ImageLoadServiceError.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

enum ImageLoaderError: LocalizedError {
    case invalidResponse
    case invalidImageData
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Failed to load image: invalid server response."
        case .invalidImageData:
            return "Failed to load image: data could not be decoded."
        case .emptyData:
            return "Failed to load image: empty response data."
        }
    }
}
