//
//  QuickActionButtonsCollectionView.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit

final class QuickActionButtonsCollectionView: UIView {
    var onTapAction: ((PetActivityType) -> Void)?
    
    lazy var quickActionCollection: UICollectionView = { collection in
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(QuickActionCell.self, forCellWithReuseIdentifier: QuickActionCell.indentifier)
        return collection
    }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: createQuickActionSection())))
    
    private func createQuickActionSection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(90)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 3)
        let section: NSCollectionLayoutSection = .init(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 6)
        return section
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(onTapAction: ((PetActivityType) -> Void)?) {
        self.init(frame: .zero)
        self.onTapAction = onTapAction
    }
    
    private func setupHierarchy() {
        addSubview(quickActionCollection)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quickActionCollection.topAnchor.constraint(equalTo: topAnchor),
            quickActionCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            quickActionCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            quickActionCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuickActionButtonsCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        PetActivityType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickActionCell.indentifier, for: indexPath) as? QuickActionCell {
            cell.configure(cellData: PetActivityType.allCases[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension QuickActionButtonsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonType = PetActivityType.allCases[indexPath.item]
        
        onTapAction?(buttonType)
    }
}
