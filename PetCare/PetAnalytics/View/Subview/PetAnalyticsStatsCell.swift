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
    
    func setData(activity: PetActivity) {
        icon = CircleIconView(
            symbolName: activity.type.icon,
            iconColor: activity.type.color,
            circleColor: activity.type.backgroundColor,
            circleSize: 45,
            iconSize: 20
        )
        // add data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
