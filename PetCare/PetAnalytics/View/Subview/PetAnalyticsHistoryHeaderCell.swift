//
//  PetAnalyticsHistoryHeaderCell.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsHistoryHeaderCell: UICollectionViewCell {
    static let identifier = "PetAnalyticsHistoryHeaderCell"
    
    private let historyTitle = TextLabel(
        font: .systemFont(
            ofSize: 18,
            weight: .semibold
        ),
        text: "Activity History",
        textAlignment: .left
    )
    
    private let viewMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("View All", for: .normal)
        button.setTitleColor(Asset.accentColor.color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private lazy var headerStack = HStack(
        distribution: .fillEqually,
        arrangedSubviews: [
            historyTitle,
            viewMoreButton
        ]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(headerStack)
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
