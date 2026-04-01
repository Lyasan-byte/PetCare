//
//  CloudinaryConfig.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

enum CloudinaryConfig {
    static func cloudName() -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_CLOUD_NAME") as? String,
              !value.isEmpty else {
            print(CloudinaryConfigError.missingCloudName)
            return ""
        }
        return value
    }
    
    static func uploadPreset() -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_UPLOAD_PRESET") as? String,
              !value.isEmpty else {
            print(CloudinaryConfigError.missingUploadPreset)
            return ""
        }
        return value
    }
}
