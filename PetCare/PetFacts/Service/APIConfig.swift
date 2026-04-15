//
//  APIConfig.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import Foundation

enum APIConfig {
    static let animalsPath = "/animals"

    static var baseURL: URL? {
        URL(string: "https://api.api-ninjas.com/v1")
    }

    static var apiNinjasKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "API_NINJAS_KEY") as? String
    }
}
