//
//  SwiftDataTipCacheService.swift
//  PetCare
//
//  Created by Ляйсан on 4/5/26.
//

import SwiftData
import Foundation

final class SwiftDataTipCacheService: TipCacheRepository {
    private let modelContext: ModelContext
    private let cacheLifetime: TimeInterval = 24 * 60 * 60

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(tips: [Tip]) throws {
        try modelContext.delete(model: CachedTip.self)

        for tip in tips {
            modelContext.insert(CachedTip(tip: tip))
        }
        try modelContext.save()
    }

    func getTips() throws -> [Tip] {
        let fetchDescriptor = FetchDescriptor<CachedTip>()
        
        let cachedTips = try modelContext.fetch(fetchDescriptor)
        
        guard !cachedTips.isEmpty else {
            return []
        }

        let isExpired = cachedTips.contains {
            Date().timeIntervalSince($0.cachedAt) > cacheLifetime
        }

        if isExpired {
            try modelContext.delete(model: CachedTip.self)
            try modelContext.save()
            return []
        }
        return cachedTips.map { $0.toDomain() }
    }
}
