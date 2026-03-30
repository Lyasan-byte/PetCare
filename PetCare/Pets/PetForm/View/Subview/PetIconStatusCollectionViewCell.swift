//
//  PetIconStatusCollectionCell.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class PetIconStatusCollectionViewCell: UICollectionViewCell {
    static let identifier = "PetIconStatusCollectionViewCell"
    private let statusView = CircleIconView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func configure(_ status: PetIconStatus, isSelected: Bool, circleSize: CGFloat, iconSize: CGFloat) {
        if isSelected {
            statusView.configure(status: status, circleSize: circleSize, iconSize: iconSize)
        } else {
            statusView.configure(symbolName: status.icon, iconColor: Asset.petGray.color, circleColor: Asset.petLightGray.color, circleSize: circleSize, iconSize: iconSize)
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(statusView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: contentView.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
