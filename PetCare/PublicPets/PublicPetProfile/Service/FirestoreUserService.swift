//
//  FirestoreUserService.swift
//  PetCare
//
//  Created by Ляйсан on 7/4/26.
//

import Foundation
import Combine
import FirebaseFirestore

final class FirestoreUserService: UserRepository {
    private let db: Firestore
    
    init(db: Firestore = .firestore()) {
        self.db = db
    }
    
    func fetchUser(for id: String) -> AnyPublisher<UserProfileUser, any Error> {
        Future { [weak self] promise in
            guard let self else { return }
            db.collection("users").document(id).getDocument { snapshot, error in
                if let error {
                    return promise(.failure(error))
                }
                
                guard let snapshot, let data = snapshot.data() else {
                    promise(.failure(NSError(
                        domain: "FirestoreUserService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "User snapshot is missing"]
                    )))
                    return
                }
                
                let user = UserProfileUser(
                    id: snapshot.documentID,
                    firstName: data["first_name"] as? String ?? "User",
                    lastName: data["last_name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    avatarURLString: data["photo_url"] as? String ?? ""
                )
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
}
