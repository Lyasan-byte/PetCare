//
//  PetCardCell.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit

final class PetCardCell: UITableViewCell {
    
    static let identifier = "PetCardCell"
    var petCard = PetCardRowView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(petCard)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            petCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            petCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(pet: Pet) {
        petCard.setData(pet: pet)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
