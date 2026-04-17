//
//  PublicPetsHeaderCollectionViewCell.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class PublicPetsHeaderCollectionViewCell: UICollectionViewCell {
    var onChangeSortOption: ((Int) -> Void)?
    
    static let identifier = "PublicPetsHeaderCollectionViewCell"

    private let header = Header(
        icon: "globe.americas.fill",
        text: L10n.Pets.Public.Header.title
    )
    private let petsOverTitle = TextLabel(
        font: .systemFont(ofSize: 11, weight: .medium),
        text: L10n.Pets.Public.Header.subtitle,
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    private let petsTitle = TextLabel(
        font: .systemFont(ofSize: 24, weight: .bold),
        text: L10n.Pets.Public.Header.feedTitle,
        textAlignment: .left
    )
    
    private let sortingButton = ButtonMenuPicker(
        symbolName: "arrow.up.arrow.down",
        options: PublicPetsSort.allCases.map(\.title)
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        bindAction()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        contentView.addSubview(header)
        contentView.addSubview(sortingButton)
        contentView.addSubview(petsOverTitle)
        contentView.addSubview(petsTitle)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: contentView.topAnchor),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            sortingButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -16),
            sortingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),

            petsOverTitle.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35),
            petsOverTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petsOverTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            petsTitle.topAnchor.constraint(equalTo: petsOverTitle.bottomAnchor, constant: 5),
            petsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            petsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func bindAction() {
        sortingButton.onChangeValue = { [weak self] value in
            self?.onChangeSortOption?(value)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
