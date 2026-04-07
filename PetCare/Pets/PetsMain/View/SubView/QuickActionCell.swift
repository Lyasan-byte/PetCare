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
    
    func configure(cellData: PetActivityType) {
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
