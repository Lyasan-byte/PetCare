//
//  PetAnalyticsHeaderCell.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsHeaderCell: UICollectionViewCell {
    static let identifier = "PetAnalyticsHeaderCell"
    
    var onChangePeriod: ((Int) -> Void)?

    private let petName = TextLabel(
        font: .systemFont(
            ofSize: 26,
            weight: .bold
        ),
        textAlignment: .left
    )
    private let petBreedAndAge = TextLabel(
        font: .systemFont(
            ofSize: 13,
            weight: .medium
        ),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    private let petImage: PetRemoteImageView = {
        let imageView = PetRemoteImageView()
        imageView.layer.cornerRadius = 37.5
        return imageView
    }()
    
    private lazy var petInfoStack = VStack(
        spacing: 5,
        arrangedSubviews: [
            petName,
            petBreedAndAge
        ]
    )
    private lazy var petProfileStack = HStack(
        alignment: .center,
        distribution: .equalSpacing,
        arrangedSubviews: [
            petInfoStack,
            petImage
        ]
    )
    
    private let periodPicker = SegmentedPickerView(
        items: PetAnalyticsPeriod.allCases.map(\.title)
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
        contentView.addSubview(petProfileStack)
        contentView.addSubview(periodPicker)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petProfileStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            petProfileStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            petProfileStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            periodPicker.topAnchor.constraint(equalTo: petProfileStack.bottomAnchor, constant: 16),
            periodPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            periodPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            periodPicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            petImage.widthAnchor.constraint(equalToConstant: 75),
            petImage.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func bindAction() {
        periodPicker.onValueChanged = { [weak self] period in
            self?.onChangePeriod?(period)
        }
    }
    
    func setData(header: PetAnalyticsHeaderData, imageLoader: ImageLoader) {
        petName.text = header.petName
        petBreedAndAge.text = header.petBreedAndAge
        petImage.setImage(urlString: header.photoUrl, imageLoader: imageLoader)
        periodPicker.setSelectedIndex(PetAnalyticsPeriod.allCases.firstIndex(of: header.selectedPeriod) ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
