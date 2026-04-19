//
//  WelcomeOnboardingView.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class WelcomeOnboardingView: UIView {
    var onSkipTap: (() -> Void)?
    var onNextTap: (() -> Void)?
    
    private let gradientBackground = GradientView()
    
    private let header = Header(icon: "pawprint.fill", text: L10n.WelcomeOnboarding.Header.text)
    private let skipButton = SkipButton()
    
    private let imageBackground = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let imageBadge = PetCardBadge(
        backgroundColor: Asset.petPurple.color,
        color: Asset.purpleAccentStatus.color,
        icon: "heart.fill",
        font: .systemFont(ofSize: 9, weight: .semibold),
        border: .tertiarySystemBackground,
        height: 40,
        iconSize: 10
    )
    private let petsImage = ImageView()
    
    private let onboardingTitle = OnboardingTitle(
        firstTitle: L10n.WelcomeOnboarding.Title.first,
        secondTitle: L10n.WelcomeOnboarding.Title.second
    )
    private let onboardingDescription = TextLabel(
        font: .systemFont(ofSize: 16, weight: .medium),
        text: L10n.WelcomeOnboarding.description,
        textColor: Asset.petGray.color
    )
    private let nextButton = PrimaryButton(
        title: L10n.WelcomeOnboarding.NextButton.title,
        shadowColor: Asset.accentColor.color
    )
    
    private lazy var headerStack = HStack(
        distribution: .equalSpacing,
        arrangedSubviews: [header, skipButton]
    )
    
    private lazy var infoStack = VStack(
        spacing: 16,
        arrangedSubviews: [onboardingTitle, onboardingDescription]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(gradientBackground)
        gradientBackground.addSubview(headerStack)
        gradientBackground.addSubview(imageBackground)
        
        imageBackground.addSubview(petsImage)
        imageBackground.addSubview(imageBadge)
        
        gradientBackground.addSubview(infoStack)
        gradientBackground.addSubview(nextButton)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerStack.topAnchor.constraint(equalTo: gradientBackground.safeAreaLayoutGuide.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -16),
            
            imageBackground.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 30),
            imageBackground.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: 16),
            imageBackground.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -16),
            imageBackground.heightAnchor.constraint(equalToConstant: 260),
            
            petsImage.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            petsImage.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor),
            petsImage.heightAnchor.constraint(equalToConstant: 220),
            
            imageBadge.trailingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: -16),
            imageBadge.bottomAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: -16),

            infoStack.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 30),
            infoStack.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -16),
            
            nextButton.leadingAnchor.constraint(equalTo: gradientBackground.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: gradientBackground.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: gradientBackground.safeAreaLayoutGuide.bottomAnchor)
         ])
    }
    
    private func configure() {
        petsImage.image = UIImage(named: "onboardingPets")
        imageBadge.setText(text: L10n.WelcomeOnboarding.ImageBadge.text)
        imageBadge.setShadow()
    }
    
    private func bindAction() {
        skipButton.onTap = { [weak self] in
            self?.onSkipTap?()
        }
        
        nextButton.onTap = { [weak self] in
            self?.onNextTap?()
        }
    }
}
