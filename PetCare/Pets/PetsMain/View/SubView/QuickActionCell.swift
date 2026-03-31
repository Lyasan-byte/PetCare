//
//  QuickActionCell.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit

class QuickActionCell: UICollectionViewCell {
    static let indentifier = "QuickActionCell"
    var layout = BackgroundView()
    var icon = ImageView()
    var titleLabel = TextLabel(font: UIFont.systemFont(ofSize: 10, weight: .semibold))
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    func configure(cellData: QuickActionCellType) {
        layout.backgroundColor = cellData.backgroundColor
        layout.layer.cornerRadius = 35
        icon.image = UIImage(systemName: cellData.icon)
        icon.tintColor = cellData.color
        titleLabel.text = cellData.name
        titleLabel.textColor = cellData.color
    }
    
    private func setupHierarchy() {
        contentView.addSubview(layout)
        layout.addSubview(icon)
        layout.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            layout.topAnchor.constraint(equalTo: contentView.topAnchor),
            layout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            layout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            icon.topAnchor.constraint(equalTo: layout.topAnchor, constant: 30),
            icon.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 25),
            icon.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum QuickActionCellType: CaseIterable {
    case walk
    case grooming
    case vet
    
    var name: String {
        switch self {
        case .walk:
            L10n.Pets.Main.QuickActions.walk
        case .grooming:
            L10n.Pets.Main.QuickActions.grooming
        case .vet:
            L10n.Pets.Main.QuickActions.vet
        }
    }
    
    var icon: String {
        switch self {
        case .walk:
            { if #available(iOS 17.0, *) { return "dog.fill" }; return "figure.walk" }()
        case .grooming:
            "scissors"
        case .vet:
            "cross.case"
        }
    }
    
    var color: UIColor {
        switch self {
        case .walk:
            Asset.accentColor.color
        case .grooming:
            Asset.purpleAccent.color
        case .vet:
            Asset.pinkAccent.color
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .walk:
            Asset.petGreenAction.color
        case .grooming:
            Asset.petPurpleAction.color
        case .vet:
            Asset.petPinkAction.color
        }
    }
}
