//
//  ImageResource.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import Foundation

enum UploadImageResource {
    case pet(id: String)
    case user(id: String)

    var folder: String {
        switch self {
        case .pet:
            return "pets"
        case .user:
            return "users"
        }
    }

    var publicId: String {
        switch self {
        case .pet(let id):
            return "pet_\(id)_\(UUID().uuidString)"
        case .user(let id):
            return "user_\(id)_\(UUID().uuidString)"
        }
    }
}
