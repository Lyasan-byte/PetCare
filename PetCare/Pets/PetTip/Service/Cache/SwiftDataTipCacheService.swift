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
        try modelContext
            .fetch(FetchDescriptor<CachedTip>())
            .map { $0.toDomain() }
    }
}
