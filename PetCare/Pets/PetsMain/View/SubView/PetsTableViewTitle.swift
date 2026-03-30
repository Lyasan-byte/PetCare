//
//  PetsTableViewTitle.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit

final class PetsTableViewTitle: UIView {
    var petsTitle1 = TextLabel(text: "Your", textAlignment: .left)
    var petsTitle2 = TextLabel(text: "Family", textAlignment: .left)
    
    lazy var petsTitleStack = VStack(arrangedSubviews: [petsTitle1, petsTitle2])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        addSubview(petsTitleStack)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petsTitleStack.topAnchor.constraint(equalTo: topAnchor),
            petsTitleStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            petsTitleStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            petsTitleStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
