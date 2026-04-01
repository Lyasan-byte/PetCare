//
//  ImageUploader.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation
import Combine

protocol ImageUploader {
    func uploadImage(data: Data, resource: UploadImageResource) -> AnyPublisher<URL, Error>
}
