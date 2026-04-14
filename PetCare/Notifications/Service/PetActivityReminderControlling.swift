//
//  PetActivityReminderControlling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 14.04.2026.
//

import Foundation

protocol PetActivityReminderControlling {
    func registerReminder(for activity: PetActivity, petName: String)
    func syncReminders(requestAuthorizationIfNeeded: Bool)
    func removeReminder(activityId: String)
    func removeAllReminders()
}
