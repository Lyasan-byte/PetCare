//
//  CloudinaryConfigError.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

enum CloudinaryConfigError: Error, LocalizedError {
    case missingCloudName
    case missingUploadPreset
    
    var errorDescription: String? {
        switch self {
        case .missingCloudName:
            return "CLOUDINARY_CLOUD_NAME is missing in Info.plist"
        case .missingUploadPreset:
            return "CLOUDINARY_UPLOAD_PRESET is missing in Info.plist"
        }
    }
}
