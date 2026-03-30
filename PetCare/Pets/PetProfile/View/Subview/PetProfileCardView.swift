//
//  PetProfileCardView.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileCardView: UIView {
    var backgroundView = BackgroundView(backgroundColor: Asset.petGray.color.withAlphaComponent(0.2))
    var petImage: UIImageView = {
        let image = ImageView(contentMode: .scaleAspectFill)
        image.layer.cornerRadius = 48
        image.layer.borderWidth = 8
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    var petStatus = CircleIconView()
    
    private let imageContainer = UIView()
    
    lazy var petNameStack = HStack(spacing: 10, alignment: .center, arrangedSubviews: [petNameLabel, isOPenProfileStatus])
    
    var petNameLabel = TextLabel(font: .systemFont(ofSize: 34, weight: .bold))
    var isOPenProfileStatus = CircleIconView(symbolName: "globe.americas.fill", circleSize: 25, iconSize: 15)
    
    var petBreedLabel = TextLabel(font: .systemFont(ofSize: 11, weight: .semibold), textColor: Asset.accentColor.color)
    
    var petAgeInfo = PetInfoRowView()
    var petGenderInfo = PetInfoRowView()
    var petWeightInfo = PetInfoRowView()
    
    lazy var petInfoStack = HStack(spacing: 5, alignment: .center, arrangedSubviews: [petAgeInfo, petGenderInfo])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(pet: Pet) {
        self.init(frame: .zero)
        configure(pet: pet)
    }
    
    private func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(imageContainer)
        backgroundView.addSubview(petNameStack)
        backgroundView.addSubview(petBreedLabel)
        backgroundView.addSubview(petInfoStack)
        backgroundView.addSubview(petWeightInfo)
        
        imageContainer.addSubview(petImage)
        imageContainer.addSubview(petStatus)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            imageContainer.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 176),
            imageContainer.heightAnchor.constraint(equalToConstant: 176),
            
            petImage.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            petImage.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            petImage.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            petImage.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            petStatus.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            petStatus.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            
            petNameStack.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 20),
            petNameStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            petBreedLabel.topAnchor.constraint(equalTo: petNameStack.bottomAnchor, constant: 5),
            petBreedLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            petBreedLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            petInfoStack.topAnchor.constraint(equalTo: petBreedLabel.bottomAnchor, constant: 15),
            petInfoStack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            petWeightInfo.topAnchor.constraint(equalTo: petInfoStack.bottomAnchor, constant: 10),
            petWeightInfo.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            petWeightInfo.widthAnchor.constraint(equalToConstant: 120),
            petWeightInfo.heightAnchor.constraint(equalToConstant: 36),
            petWeightInfo.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            
            petAgeInfo.widthAnchor.constraint(equalToConstant: 120),
            petAgeInfo.heightAnchor.constraint(equalToConstant: 36),
            petGenderInfo.widthAnchor.constraint(equalToConstant: 120),
            petGenderInfo.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
        
    private func configure(pet: Pet) {
        petImage.image = UIImage(named: "defaulProfilePhoto")
        petNameLabel.text = pet.name
        petBreedLabel.text = pet.breed.uppercased()
        petAgeInfo.setData(info: "Age: \(pet.ageText)")
        petWeightInfo.setData(info: "Weight: \(pet.weight) kg")
        petGenderInfo.setData(info: "Gender: \(pet.gender.rawValue.capitalized)")
        
        petStatus.configure(status: pet.iconStatus, circleSize: 40, iconSize: 25)
        
        isOPenProfileStatus.isHidden = !pet.isPublic
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



