//
//  WelcomeOnboardingView.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class WelcomeOnboardingView: UIView, OnboardingPageView {
    var onSkipTap: (() -> Void)? {
        get { templateView.onSkipTap }
        set { templateView.onSkipTap = newValue }
    }

    var onNextTap: (() -> Void)? {
        get { templateView.onNextTap }
        set { templateView.onNextTap = newValue }
    }

    private let templateView = OnboardingTemplateView(
        content: OnboardingPageContent(
            firstTitle: L10n.WelcomeOnboarding.Title.first,
            secondTitle: L10n.WelcomeOnboarding.Title.second,
            description: L10n.WelcomeOnboarding.description,
            buttonTitle: L10n.WelcomeOnboarding.NextButton.title,
            currentPage: 0,
            totalPages: 3,
            heroHeight: 260
        ),
        heroView: WelcomeOnboardingHeroView()
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(templateView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            templateView.topAnchor.constraint(equalTo: topAnchor),
            templateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            templateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            templateView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
