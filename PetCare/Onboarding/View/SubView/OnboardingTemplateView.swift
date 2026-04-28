//
//  OnboardingTemplateView.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class OnboardingTemplateView: UIView {
    var onSkipTap: (() -> Void)?
    var onNextTap: (() -> Void)?

    private let content: OnboardingPageContent
    private let heroView: UIView

    private let gradientBackground = GradientView()
    private let header = Header(
        icon: "pawprint.fill",
        text: L10n.WelcomeOnboarding.Header.text
    )
    private let skipButton = SkipButton()
    private let heroContainer = BackgroundView(
        backgroundColor: .tertiarySystemBackground
    )

    private lazy var titleView = OnboardingTitle(
        firstTitle: content.firstTitle,
        secondTitle: content.secondTitle
    )
    private let descriptionLabel = TextLabel(
        font: .systemFont(ofSize: 16, weight: .medium),
        textColor: Asset.petGray.color
    )
    private lazy var pageIndicator = OnboardingPageIndicatorView(
        currentPage: content.currentPage,
        totalPages: content.totalPages
    )
    private let pageIndicatorContainer = UIView()
    private lazy var nextButton = PrimaryButton(
        title: content.buttonTitle,
        shadowColor: Asset.accentColor.color
    )

    private lazy var headerStack = HStack(
        distribution: .equalSpacing,
        arrangedSubviews: [header, skipButton]
    )

    private lazy var infoStack = VStack(
        spacing: 16,
        arrangedSubviews: [titleView, descriptionLabel]
    )
    private lazy var contentStack = VStack(
        spacing: 28,
        arrangedSubviews: [heroContainer, infoStack, pageIndicatorContainer, nextButton]
    )

    init(content: OnboardingPageContent, heroView: UIView) {
        self.content = content
        self.heroView = heroView
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        configure()
        bindAction()
    }

    private func setupHierarchy() {
        addSubview(gradientBackground)
        gradientBackground.addSubview(headerStack)
        gradientBackground.addSubview(contentStack)
        heroContainer.addSubview(heroView)
        pageIndicatorContainer.addSubview(pageIndicator)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        let centeredConstraint = contentStack.centerYAnchor.constraint(
            equalTo: gradientBackground.centerYAnchor,
            constant: 26
        )
        centeredConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: bottomAnchor),

            headerStack.topAnchor.constraint(
                equalTo: gradientBackground.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            headerStack.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -16),

            contentStack.topAnchor.constraint(greaterThanOrEqualTo: headerStack.bottomAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: gradientBackground.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            centeredConstraint,

            heroContainer.heightAnchor.constraint(equalToConstant: content.heroHeight),

            pageIndicator.topAnchor.constraint(equalTo: pageIndicatorContainer.topAnchor),
            pageIndicator.centerXAnchor.constraint(equalTo: pageIndicatorContainer.centerXAnchor),
            pageIndicator.bottomAnchor.constraint(equalTo: pageIndicatorContainer.bottomAnchor),

            heroView.topAnchor.constraint(equalTo: heroContainer.topAnchor, constant: 16),
            heroView.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor, constant: 16),
            heroView.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor, constant: -16),
            heroView.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor, constant: -16)
        ])
    }

    private func configure() {
        descriptionLabel.text = content.description
        descriptionLabel.textAlignment = .center
        pageIndicator.setContentHuggingPriority(.required, for: .vertical)
        nextButton.setContentHuggingPriority(.required, for: .vertical)
    }

    private func bindAction() {
        skipButton.onTap = { [weak self] in
            self?.onSkipTap?()
        }

        nextButton.onTap = { [weak self] in
            self?.onNextTap?()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
