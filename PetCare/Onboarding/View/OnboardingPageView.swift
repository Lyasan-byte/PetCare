//
//  OnboardingPageView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

protocol OnboardingPageView: UIView {
    var onSkipTap: (() -> Void)? { get set }
    var onNextTap: (() -> Void)? { get set }
}
