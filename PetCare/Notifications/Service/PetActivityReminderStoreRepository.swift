//
//  PetActivityReminderStoreRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13.04.2026.
//

import Foundation

protocol PetActivityReminderStoreRepository {
    func fetchReminders(for ownerId: String) -> [PetActivityReminder]
    func save(_ reminder: PetActivityReminder)
    func removeReminder(activityId: String, ownerId: String)
    func removeAllReminders(for ownerId: String)
}
