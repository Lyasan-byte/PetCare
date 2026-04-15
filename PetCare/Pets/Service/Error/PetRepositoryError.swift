//
//  PetRepositoryError.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import Foundation

enum RepositoryError: LocalizedError {
    case deallocated
    case unknown

    var errorDescription: String? {
        switch self {
        case .deallocated:
            return L10n.Repository.Error.deallocated
        case .unknown:
            return L10n.Repository.Error.unknown
        }
    }
}
