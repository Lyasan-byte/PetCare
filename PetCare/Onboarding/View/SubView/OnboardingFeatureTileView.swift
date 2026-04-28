//
//  OnboardingFeatureTileView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class OnboardingFeatureTileView: UIView {
    private let background: BackgroundView
    private let iconView: CircleIconView
    private let titleLabel: TextLabel
    private lazy var contentStack = VStack(
        spacing: 10,
        alignment: .center,
        arrangedSubviews: [iconView, titleLabel]
    )

    init(
        backgroundColor: UIColor,
        iconBackgroundColor: UIColor,
        iconTintColor: UIColor,
        titleColor: UIColor,
        iconName: String,
        title: String,
        iconSize: CGFloat = 22,
        iconWeight: UIImage.SymbolWeight = .semibold
    ) {
        self.background = BackgroundView(
            backgroundColor: backgroundColor,
            cornerRadius: 26
        )
        self.iconView = CircleIconView(
            symbolName: iconName,
            iconColor: iconTintColor,
            circleColor: iconBackgroundColor,
            circleSize: 52,
            iconSize: iconSize,
            weight: iconWeight
        )
        self.titleLabel = TextLabel(
            font: .systemFont(ofSize: 10, weight: .semibold),
            text: title,
            textColor: titleColor
        )

        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        configure()
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(contentStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }

    private func configure() {
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
