//
//  ImageUploaderService.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation
import Cloudinary
import Combine

final class ImageUploadService: ImageUploader {
    private let cloudinary: CLDCloudinary
    private let uploadPreset: String
    
    init(cloudName: String = CloudinaryConfig.cloudName(), uploadPreset: String = CloudinaryConfig.uploadPreset()) {
        let configuration = CLDConfiguration(cloudName: cloudName)
        self.cloudinary = CLDCloudinary(configuration: configuration)
        self.uploadPreset = uploadPreset
    }
    
    func uploadImage(data: Data, resource: UploadImageResource) -> AnyPublisher<URL, Error> {
        Future { [cloudinary, uploadPreset] promise in
            let params = CLDUploadRequestParams()
            params.setFolder(resource.folder)
            params.setPublicId(resource.publicId)
            
            cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset, params: params, progress: nil) { response, error in
                if let error {
                    promise(.failure(error))
                    return
                }
                
                guard let response else {
                    promise(.failure(ImageUploadServiceError.invalidUploadResponse))
                    return
                }

                guard let secureURLString = response.secureUrl else {
                    promise(.failure(ImageUploadServiceError.missingSecureURL))
                    return
                }

                guard let url = URL(string: secureURLString) else {
                    promise(.failure(ImageUploadServiceError.invalidSecureURL(secureURLString)))
                    return
                }
                
                promise(.success(url))
            }
        }
        .eraseToAnyPublisher()
    }
}
