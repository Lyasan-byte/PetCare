//
//  PetFactsView.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import UIKit

final class PetFactsView: UIView {
    var onCloseTap: (() -> Void)?

    private let background = BackgroundView(backgroundColor: .systemBackground, cornerRadius: 0)
    private let collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = PetFactsSection(rawValue: sectionIndex) else {
                return nil
            }

            switch section {
            case .header:
                return createHeaderSection()
            case .generalInfo:
                return createGeneralInfoSection()
            case .details:
                return createDetailsSection()
            }
        }
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "По данной породе не найдено информации"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let closeButton = PrimaryButton(title: "Close")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupAction()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func setupAction() {
        closeButton.onTap = { [weak self] in
            self?.onCloseTap?()
        }
    }

    func setupCollection(dataSource: UICollectionViewDataSource) {
        collection.dataSource = dataSource
    }

    func registerCells() {
        collection
            .register(
                PetFactsHeaderCollectionViewCell.self,
                forCellWithReuseIdentifier: PetFactsHeaderCollectionViewCell.identifier
            )
        collection
            .register(
                PetFactCollectionViewCell.self,
                forCellWithReuseIdentifier: PetFactCollectionViewCell.identifier
            )
    }

    func reloadData() {
        collection.reloadData()
    }

    func setEmptyState(_ isEmpty: Bool) {
        collection.isHidden = isEmpty
        emptyStateLabel.isHidden = !isEmpty
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(collection)
        background.addSubview(emptyStateLabel)
        background.addSubview(closeButton)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            collection.topAnchor.constraint(equalTo: background.topAnchor),
            collection.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: background.bottomAnchor),

            emptyStateLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -24),

            closeButton.leadingAnchor.constraint(equalTo: collection.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: collection.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: collection.bottomAnchor, constant: -32)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetFactsView {
    private static func createHeaderSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(210)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(210)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    private static func createGeneralInfoSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(100)
            )
        )
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16)
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            ),
            repeatingSubitem: item,
            count: 2
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 40, leading: 16, bottom: 0, trailing: 0)
        section.interGroupSpacing = 16
        return section
    }

    private static func createDetailsSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated( 200)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }
}
