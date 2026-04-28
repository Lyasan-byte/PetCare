//
//  OnboardingStateRepository.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import Foundation

protocol OnboardingStateRepository {
    func hasSeenOnboarding() -> Bool
    func setHasSeenOnboarding(_ value: Bool)
}
