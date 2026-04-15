//
//  PetActivityReminderController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13.04.2026.
//

import Foundation
import UserNotifications

final class PetActivityReminderController: PetActivityReminderControlling {
    private let ownerId: String
    private let settingsRepository: SettingsRepository
    private let localNotificationsRepository: LocalNotificationsRepository
    private let reminderStoreRepository: PetActivityReminderStoreRepository
    private let calendar: Calendar

    init(
        ownerId: String,
        settingsRepository: SettingsRepository,
        localNotificationsRepository: LocalNotificationsRepository,
        reminderStoreRepository: PetActivityReminderStoreRepository,
        calendar: Calendar = .current
    ) {
        self.ownerId = ownerId
        self.settingsRepository = settingsRepository
        self.localNotificationsRepository = localNotificationsRepository
        self.reminderStoreRepository = reminderStoreRepository
        self.calendar = calendar
    }

    func registerReminder(for activity: PetActivity, petName: String) {
        guard let activityId = activity.id else { return }

        if activity.isReminder {
            let reminder = PetActivityReminder(
                activityId: activityId,
                ownerId: ownerId,
                petId: activity.petId,
                petName: petName,
                activityType: activity.type,
                date: activity.date
            )
            reminderStoreRepository.save(reminder)
            syncReminders(requestAuthorizationIfNeeded: true)
        } else {
            removeReminder(activityId: activityId)
        }
    }

    func syncReminders(requestAuthorizationIfNeeded: Bool) {
        let reminders = reminderStoreRepository.fetchReminders(for: ownerId)
        let identifiers = reminders.map(\.notificationIdentifier)

        guard !identifiers.isEmpty else { return }

        localNotificationsRepository.removePendingRequests(withIdentifiers: identifiers)
        localNotificationsRepository.removeDeliveredNotifications(withIdentifiers: identifiers)

        let settings = settingsRepository.loadSettings()
        let allowedReminders = reminders.filter {
            isReminderEnabled(for: $0.activityType, settings: settings)
        }

        guard !allowedReminders.isEmpty else { return }

        schedule(
            reminders: allowedReminders,
            requestAuthorizationIfNeeded: requestAuthorizationIfNeeded
        )
    }

    func removeReminder(activityId: String) {
        let reminder = reminderStoreRepository
            .fetchReminders(for: ownerId)
            .first { $0.activityId == activityId }
        reminderStoreRepository.removeReminder(activityId: activityId, ownerId: ownerId)

        guard let reminder else { return }

        localNotificationsRepository.removePendingRequests(withIdentifiers: [reminder.notificationIdentifier])
        localNotificationsRepository.removeDeliveredNotifications(withIdentifiers: [reminder.notificationIdentifier])
    }

    func removeAllReminders() {
        let reminders = reminderStoreRepository.fetchReminders(for: ownerId)
        let identifiers = reminders.map(\.notificationIdentifier)
        reminderStoreRepository.removeAllReminders(for: ownerId)

        guard !identifiers.isEmpty else { return }

        localNotificationsRepository.removePendingRequests(withIdentifiers: identifiers)
        localNotificationsRepository.removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    private func schedule(
        reminders: [PetActivityReminder],
        requestAuthorizationIfNeeded: Bool
    ) {
        localNotificationsRepository.authorizationStatus { [weak self] status in
            guard let self else { return }

            switch status {
            case .authorized, .provisional, .ephemeral:
                self.scheduleAuthorizedReminders(reminders)
            case .notDetermined:
                guard requestAuthorizationIfNeeded else { return }
                self.localNotificationsRepository.requestAuthorization { [weak self] isGranted in
                    guard isGranted else { return }
                    self?.scheduleAuthorizedReminders(reminders)
                }
            case .denied:
                return
            @unknown default:
                return
            }
        }
    }

    private func scheduleAuthorizedReminders(_ reminders: [PetActivityReminder]) {
        reminders.forEach { reminder in
            localNotificationsRepository.add(makeRequest(for: reminder), completion: nil)
        }
    }

    private func makeRequest(for reminder: PetActivityReminder) -> UNNotificationRequest {
        UNNotificationRequest(
            identifier: reminder.notificationIdentifier,
            content: makeContent(for: reminder),
            trigger: makeTrigger(for: reminder)
        )
    }

    private func makeContent(for reminder: PetActivityReminder) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = reminder.activityType.notificationTitle
        content.body = String(
            format: reminder.activityType.notificationBodyFormat,
            reminder.petName
        )
        return content
    }

    private func makeTrigger(for reminder: PetActivityReminder) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = calendar.timeZone
        dateComponents.hour = 9
        dateComponents.minute = 0

        switch reminder.activityType {
        case .walk:
            break
        case .grooming, .vet:
            dateComponents.day = calendar.component(.day, from: reminder.date)
        }

        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }

    private func isReminderEnabled(
        for activityType: PetActivityType,
        settings: SettingsDisplayData
    ) -> Bool {
        guard settings.isNotificationsEnabled else { return false }

        switch activityType {
        case .walk:
            return settings.isWalkEnabled
        case .grooming:
            return settings.isGroomingEnabled
        case .vet:
            return settings.isVeterinarianEnabled
        }
    }
}
