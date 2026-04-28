//
//  OnboardingTitle.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class OnboardingTitle: UIView {
    private let firstTitle = TextLabel(
        font: .systemFont(ofSize: 28, weight: .bold)
    )
    
    private let secondTitle = TextLabel(
        font: .systemFont(ofSize: 28, weight: .bold),
        textColor: Asset.accentColor.color
    )
    
    private lazy var contentStack = VStack(
        spacing: 0,
        alignment: .center,
        distribution: .equalCentering,
        arrangedSubviews: [firstTitle, secondTitle]
    )
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(firstTitle: String, secondTitle: String) {
        self.init(frame: .zero)
        self.firstTitle.text = firstTitle
        self.secondTitle.text = secondTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(contentStack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
