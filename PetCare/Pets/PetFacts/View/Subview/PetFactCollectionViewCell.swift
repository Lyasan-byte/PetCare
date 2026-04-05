//
//  PetFactCollectionViewCell.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import UIKit

final class PetFactCollectionViewCell: UICollectionViewCell {
    static let identifier = "PetFactCollectionViewCell"
    
    private let background = BackgroundView()
    private let factTitle = TextLabel(
        font: .systemFont(
            ofSize: 12,
            weight: .semibold
        ),
        textAlignment: .left
    )
    private let factInfo = TextLabel(
        font: .systemFont(
            ofSize: 16
        ),
        textAlignment: .left
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(backgroundColor: UIColor, textColor: UIColor) {
        self.init(frame: .zero)
        self.background.backgroundColor = backgroundColor
        self.factTitle.textColor = textColor
        self.factInfo.textColor = textColor
    }
    
    private func setupHierarchy() {
        contentView.addSubview(background)
        background.addSubview(factTitle)
        background.addSubview(factInfo)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            factTitle.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            factTitle.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            factTitle.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            
            factInfo.topAnchor.constraint(equalTo: factTitle.bottomAnchor, constant: 16),
            factInfo.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            factInfo.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            factInfo.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(row: PetFactRow) {
        factTitle.text = row.title
        factInfo.text = row.value
        
        factTitle.textColor = row.valueColor
        factInfo.textColor = row.valueColor
        
        background.backgroundColor = row.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
