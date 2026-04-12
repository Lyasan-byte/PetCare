//
//  PetAnalyticsHistoryCell.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsHistoryCell: UICollectionViewCell {
    static let identifier = "PetAnalyticsHistoryCell"
    
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let activityName = TextLabel(
        font: .systemFont(
            ofSize: 16,
            weight: .semibold
        ),
        textAlignment: .left
    )
    private let activityDate = TextLabel(
        font: .systemFont(
            ofSize: 14,
            weight: .regular
        ),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    private let activityDescription = TextLabel(
        font: .systemFont(
            ofSize: 15,
            weight: .semibold
        ),
        textAlignment: .left
    )
    
    private var icon = CircleIconView()
    
    private lazy var activityInfoStack = VStack(
        spacing: 10,
        arrangedSubviews: [
            activityName,
            activityDate
        ]
    )
    private lazy var contentStack = HStack(
        spacing: 16,
        distribution: .fillEqually,
        arrangedSubviews: [
            icon,
            activityInfoStack,
            activityDescription
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
    
    func setData(history: PetAnalyticsHistoryData) {
        let activityType = history.activityType
        icon = CircleIconView(
            symbolName: activityType.icon,
            iconColor: activityType.color,
            circleColor: activityType.activityBackgroundColor,
            circleSize: 45,
            iconSize: 20
        )
        activityName.text = activityType.name
        
        activityDate.text = history.date
        activityDescription.text = history.activityDetail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
