//
//  PetActivityCreationCollectionView.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class PetActivityCreationCollectionView: UIView {
    private let collectionTitle = TextLabel(
        font: .systemFont(
            ofSize: 11,
            weight: .medium
        ),
        text: L10n.Pets.Activity.selectPet,
        textColor: Asset.petGray.color,
        textAlignment: .left
    )

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = PetActivityCreationSection(rawValue: sectionIndex) else {
                return nil
            }
            switch section {
            case .petPhotoSelection:
                return createPetSelectionSection()
            }
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(collectionTitle)
        addSubview(collectionView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            collectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionTitle.trailingAnchor.constraint(equalTo: trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    func setupCollection(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate
    ) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }

    func registerCell() {
        collectionView.register(
            PetSelectionCollectionViewCell.self,
            forCellWithReuseIdentifier: PetSelectionCollectionViewCell.identifier
        )
    }

    func reloadData() {
        collectionView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetActivityCreationCollectionView {
    private static func createPetSelectionSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .absolute(65),
                heightDimension: .absolute(95)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(65),
                heightDimension: .absolute(95)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}
