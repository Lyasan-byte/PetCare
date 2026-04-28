//
//  CommunityOnboardingView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class CommunityOnboardingView: UIView, OnboardingPageView {
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
            firstTitle: L10n.OnboardingCommunity.Title.first,
            secondTitle: L10n.OnboardingCommunity.Title.second,
            description: L10n.OnboardingCommunity.description,
            buttonTitle: L10n.OnboardingCommunity.NextButton.title,
            currentPage: 2,
            totalPages: 3,
            heroHeight: 300
        ),
        heroView: CommunityOnboardingHeroView()
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
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
