//
//  UserNotificationCenterService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13.04.2026.
//

import Foundation
import UserNotifications

final class UserNotificationCenterService: LocalNotificationsRepository {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func authorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { isGranted, _ in
            completion(isGranted)
        }
    }

    func add(_ request: UNNotificationRequest, completion: ((Error?) -> Void)?) {
        center.add(request) { error in
            completion?(error)
        }
    }

    func removePendingRequests(withIdentifiers identifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
    }
}
