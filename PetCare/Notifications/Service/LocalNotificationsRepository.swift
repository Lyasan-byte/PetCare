//
//  LocalNotificationsRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13.04.2026.
//

import Foundation
import UserNotifications

protocol LocalNotificationsRepository {
    func authorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func add(_ request: UNNotificationRequest, completion: ((Error?) -> Void)?)
    func removePendingRequests(withIdentifiers identifiers: [String])
    func removeDeliveredNotifications(withIdentifiers identifiers: [String])
}
