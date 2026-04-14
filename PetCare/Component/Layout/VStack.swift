//
//  VStack.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class VStack: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(
        spacing: CGFloat = 5,
        alignment: UIStackView.Alignment = .fill,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(frame: .zero)
        self.spacing = spacing
        self.alignment = alignment
        arrangedSubviews.forEach { addArrangedSubview($0) }
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
