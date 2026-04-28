//
//  UserDefaultsOnboardingStateService.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import Foundation

final class UserDefaultsOnboardingStateService: OnboardingStateRepository {
    private enum Keys {
        static let hasSeenOnboarding = "onboarding.hasSeen"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func hasSeenOnboarding() -> Bool {
        userDefaults.bool(forKey: Keys.hasSeenOnboarding)
    }

    func setHasSeenOnboarding(_ value: Bool) {
        userDefaults.set(value, forKey: Keys.hasSeenOnboarding)
    }
}
