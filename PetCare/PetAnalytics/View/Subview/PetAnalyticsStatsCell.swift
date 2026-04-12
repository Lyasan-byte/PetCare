//
//  PetAnalyticsStatsCell.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsStatsCell: UICollectionViewCell {
    static let identifier = "PetAnalyticsStatsCell"
    
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let statsTitle = TextLabel(
        font: .systemFont(
            ofSize: 13,
            weight: .semibold
        ),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    private let statsValue = TextLabel(
        font: .systemFont(
            ofSize: 18,
            weight: .semibold
        ),
        textAlignment: .left
    )

    private var icon = CircleIconView()
    
    private lazy var statsInfoStack = VStack(
        spacing: 10,
        arrangedSubviews: [
            statsTitle,
            statsValue
        ]
    )
    private lazy var contentStack = HStack(
        spacing: 16,
        arrangedSubviews: [
            icon,
            statsInfoStack
        ]
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
        contentView.addSubview(background)
        background.addSubview(contentStack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(stats: PetAnalyticsStatsData) {
        icon = CircleIconView(
            symbolName: stats.style.icon,
            iconColor: iconColor(for: stats.style),
            circleColor: backgroundColor(for: stats.style),
            circleSize: 45,
            iconSize: 20
        )
        self.statsTitle.text = stats.title
        self.statsValue.text = stats.value
    }
    
    private func iconColor(for style: PetAnalyticsStatsStyle) -> UIColor {
        switch style {
        case .walks:
            Asset.primaryGreen.color
        case .averageDistance:
            Asset.purpleAccentStatus.color
        case .spendings:
            Asset.petYellow.color
        }
    }
    
    private func backgroundColor(for style: PetAnalyticsStatsStyle) -> UIColor {
        switch style {
        case .walks:
            Asset.petGreenAction.color
        case .averageDistance:
            Asset.petPurpleAction.color
        case .spendings:
            Asset.yellowAccent.color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
