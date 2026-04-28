//
//  PetFactsViewController.swift
//  PetCare
//
//  Created by Ляйсан on 5/4/26.
//

import UIKit

final class PetFactsViewController: UIViewController {
    private let petFactsView = PetFactsView()
    private let petFact: PetFact?

    private var generalInfoRows: [PetFactRow] = []
    private var detailsRows: [PetFactRow] = []

    var onClose: (() -> Void)?

    init(petFact: PetFact?) {
        self.petFact = petFact
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(petFactsView)
        setupLayout()
        setupCollection()
        setupAction()

        if let petFact {
            buildRows(for: petFact)
            petFactsView.setEmptyState(false)
            petFactsView.reloadData()
        } else {
            petFactsView.setEmptyState(true)
        }
    }

    private func setupCollection() {
        petFactsView.setupCollection(dataSource: self)
        petFactsView.registerCells()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            petFactsView.topAnchor.constraint(equalTo: view.topAnchor),
            petFactsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petFactsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petFactsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAction() {
        petFactsView.onCloseTap = { [weak self] in
            self?.onClose?()
        }
    }

    private func buildRows(for petFact: PetFact) {
        generalInfoRows = [
            makeRow(
                title: L10n.Pets.Facts.group,
                value: petFact.group,
                backgrounColor: Asset.lightGreen.color,
                valueColor: Asset.accentColor.color
            ),
            makeRow(
                title: L10n.Pets.Facts.lifespan,
                value: petFact.lifespan,
                backgrounColor: Asset.lightPink.color,
                valueColor: Asset.pinkAccent.color
            ),
            makeRow(
                title: L10n.Pets.Facts.diet,
                value: petFact.diet,
                backgrounColor: Asset.lightPurple.color,
                valueColor: Asset.purpleAccent.color
            ),
            makeRow(
                title: L10n.Pets.Facts.skinType,
                value: petFact.skinType,
                backgrounColor: Asset.lightGreen.color,
                valueColor: Asset.accentColor.color
            )
        ].compactMap { $0 }

        detailsRows = [
            makeRow(
                title: L10n.Pets.Facts.weight,
                value: petFact.weight,
                backgrounColor: Asset.lightPink.color,
                valueColor: Asset.pinkAccent.color
            ),
            makeRow(
                title: L10n.Pets.Facts.locations,
                value: petFact.locations.isEmpty ? nil : petFact.locations.joined(
                    separator: ", "
                ),
                backgrounColor: Asset.lightPurple.color,
                valueColor: Asset.purpleAccent.color
            )
        ].compactMap { $0 }
    }

    private func makeRow(title: String, value: String?, backgrounColor: UIColor, valueColor: UIColor) -> PetFactRow? {
        guard let value else { return nil }
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else { return nil }
        return PetFactRow(title: title, value: trimmedValue, backgroundColor: backgrounColor, valueColor: valueColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetFactsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard petFact != nil else { return 0 }
        return PetFactsSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard petFact != nil,
            let section = PetFactsSection(rawValue: section) else {
            return 0
        }

        switch section {
        case .header:
            return 1
        case .generalInfo:
            return generalInfoRows.count
        case .details:
            return detailsRows.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let petFact,
            let section = PetFactsSection(rawValue: indexPath.section) else {
            assertionFailure("cellForItemAt called while petFact is nil")
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: PetFactCollectionViewCell.identifier,
                for: indexPath
            )
        }

        switch section {
        case .header:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetFactsHeaderCollectionViewCell.identifier,
                for: indexPath
            ) as? PetFactsHeaderCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.setData(breed: petFact.petName, petCharacteristic: petFact.characteristic)
            return cell

        case .generalInfo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetFactCollectionViewCell.identifier,
                for: indexPath
            ) as? PetFactCollectionViewCell else {
                return UICollectionViewCell()
            }

            let row = generalInfoRows[indexPath.item]
            cell.setData(row: row)
            return cell

        case .details:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetFactCollectionViewCell.identifier,
                for: indexPath
            ) as? PetFactCollectionViewCell else {
                return UICollectionViewCell()
            }

            let row = detailsRows[indexPath.item]
            cell.setData(row: row)
            return cell
        }
    }
}
