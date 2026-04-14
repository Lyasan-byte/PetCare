//
//  UserDefaultsPetActivityReminderStore.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13.04.2026.
//

import Foundation

final class UserDefaultsPetActivityReminderStore: PetActivityReminderStoreRepository {
    private enum Keys {
        static let reminders = "notifications.petActivityReminders"
    }

    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func fetchReminders(for ownerId: String) -> [PetActivityReminder] {
        loadAllReminders()
            .filter { $0.ownerId == ownerId }
    }

    func save(_ reminder: PetActivityReminder) {
        var reminders = loadAllReminders()
        reminders.removeAll {
            $0.ownerId == reminder.ownerId &&
                $0.petId == reminder.petId &&
                $0.activityType == reminder.activityType
        }
        reminders.append(reminder)
        persist(reminders)
    }

    func removeReminder(activityId: String, ownerId: String) {
        let reminders = loadAllReminders().filter {
            !($0.ownerId == ownerId && $0.activityId == activityId)
        }
        persist(reminders)
    }

    func removeAllReminders(for ownerId: String) {
        let reminders = loadAllReminders().filter { $0.ownerId != ownerId }
        persist(reminders)
    }

    private func loadAllReminders() -> [PetActivityReminder] {
        guard let data = userDefaults.data(forKey: Keys.reminders) else {
            return []
        }

        return (try? decoder.decode([PetActivityReminder].self, from: data)) ?? []
    }

    private func persist(_ reminders: [PetActivityReminder]) {
        let data = try? encoder.encode(reminders)
        userDefaults.set(data, forKey: Keys.reminders)
    }
}
