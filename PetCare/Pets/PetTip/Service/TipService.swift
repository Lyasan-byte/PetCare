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
    private let tipsCollection = Firestore.firestore().collection("tips")

    func fetchTips() -> AnyPublisher<[Tip], any Error> {
        Future { [weak self] promise in
            guard let self else { return promise(.failure(TipServiceError.tipServiceDeallocated))}

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
                    promise(.success(tips))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
