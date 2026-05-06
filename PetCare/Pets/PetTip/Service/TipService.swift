//
//  TipService.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Foundation
import FirebaseFirestore
import Combine

enum TipServiceError: Error {
    case tipServiceDeallocated
}

final class TipService: TipRepository {
    private let cache: TipCacheRepository
    
    private let tipsCollection = Firestore.firestore().collection("tips")
    
    init(cache: TipCacheRepository) {
        self.cache = cache
    }

    func fetchTips() -> AnyPublisher<[Tip], any Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(TipServiceError.tipServiceDeallocated))}
            
            do {
                let cachedTips = try self.cache.getTips()
                if !cachedTips.isEmpty {
                    promise(.success(cachedTips))
                    return
                }
            } catch {
                print("Cache read error:", error)
            }

            tipsCollection.getDocuments { snapshot, error in
                if let error {
                    promise(.failure(error))
                    return
                }

                guard let snapshot else {
                    promise(.success([]))
                    return
                }
                do {
                    let tips = try snapshot.documents.map { try $0.data(as: Tip.self) }
                    
                    do {
                        try self.cache.save(tips: tips)
                    } catch {
                        print("Failed to cache tips", error)
                    }
                    promise(.success(tips))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
