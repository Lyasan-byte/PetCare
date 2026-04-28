//
//  DeepLConfig.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.04.2026.
//

import Foundation

enum DeepLConfig {
    static let translatePath = "/v2/translate"

    static var baseURL: URL? {
        if let rawValue = Bundle.main.object(forInfoDictionaryKey: "DEEPL_API_BASE_URL") as? String,
            !rawValue.isEmpty {
            return URL(string: rawValue)
        }

        return URL(string: "https://api-free.deepl.com")
    }

    static var apiKey: String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "DEEPL_API_KEY") as? String,
            !value.isEmpty else {
            return nil
        }

        return value
    }
}
