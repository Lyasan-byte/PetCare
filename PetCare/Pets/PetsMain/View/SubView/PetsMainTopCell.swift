//
//  PetsMainTopCell.swift
//  PetCare
//
//  Created by Ляйсан on 1/4/26.
//

import UIKit

final class PetsMainTopCell: UICollectionViewCell {
    static let identifier = "PetsMainTopCell"
    
    private let header = Header(icon: "pawprint.fill", text: L10n.Pets.Main.title)
    private let quickActionsButtonsHeader = QuickActionButtonsHeader()
    private let quickActionButtonsCollection = QuickActionButtonsCollectionView()
    private let tip = TipView()
    private let petTableViewTitle = TextLabel(
        text: L10n.Pets.Main.familyTitle,
        textAlignment: .left
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(header)
        contentView.addSubview(quickActionsButtonsHeader)
        contentView.addSubview(quickActionButtonsCollection)
        contentView.addSubview(tip)
        contentView.addSubview(petTableViewTitle)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: contentView.topAnchor),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quickActionsButtonsHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35),
            quickActionsButtonsHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quickActionsButtonsHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quickActionButtonsCollection.topAnchor.constraint(equalTo: quickActionsButtonsHeader.bottomAnchor, constant: 10),
            quickActionButtonsCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quickActionButtonsCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quickActionButtonsCollection.heightAnchor.constraint(equalToConstant: 110),
            
            tip.topAnchor.constraint(equalTo: quickActionButtonsCollection.bottomAnchor, constant: 10),
            tip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tip.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            petTableViewTitle.topAnchor.constraint(equalTo: tip.bottomAnchor, constant: 10),
            petTableViewTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            petTableViewTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            petTableViewTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(
        tipText: String,
        onTipTap: (() -> Void)?,
        onQuickActionTap: ((QuickActionCellType) -> Void)?
    ) {
        tip.setText(text: tipText)
        tip.onTipTap = onTipTap
        quickActionButtonsCollection.onTapAction = onQuickActionTap
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
