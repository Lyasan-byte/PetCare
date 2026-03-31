//
//  PetIconStatusPicker.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class PetIconStatusPicker: UIView {
    var onSelectStatus: ((PetIconStatus) -> Void)?
    
    private let pickerTitle = TextLabel(font: .systemFont(ofSize: 11, weight: .medium), text: "SELECT ICON", textColor: Asset.petGray.color, textAlignment: .left)
    
    private lazy var petStatusCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: createSection()))
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(PetIconStatusCollectionViewCell.self, forCellWithReuseIdentifier: PetIconStatusCollectionViewCell.identifier)
        return collection
    }()
    
    private let statuses = PetIconStatus.allCases
    private var selectedStatus: PetIconStatus = PetIconStatus.none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    private func setupHierarchy() {
        addSubview(pickerTitle)
        addSubview(petStatusCollectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            pickerTitle.topAnchor.constraint(equalTo: topAnchor),
            pickerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            petStatusCollectionView.topAnchor.constraint(equalTo: pickerTitle.bottomAnchor, constant: 10),
            petStatusCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            petStatusCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            petStatusCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func select(_ status: PetIconStatus) {
        guard selectedStatus != status else { return }
        selectedStatus = status
        petStatusCollectionView.reloadData()
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .absolute(52), heightDimension: .absolute(52)))
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .absolute(52), heightDimension: .absolute(52)), repeatingSubitem: item, count: 1)
        let section: NSCollectionLayoutSection = .init(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        return section
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetIconStatusPicker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statuses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetIconStatusCollectionViewCell.identifier, for: indexPath) as? PetIconStatusCollectionViewCell {
            let isSelectedStatus = statuses[indexPath.row] == selectedStatus
            cell.configure(statuses[indexPath.row], isSelected: isSelectedStatus, circleSize: 52, iconSize: 20)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension PetIconStatusPicker: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedStatus = self.statuses[indexPath.item]
        collectionView.reloadData()
        
        onSelectStatus?(selectedStatus)
    }
}
