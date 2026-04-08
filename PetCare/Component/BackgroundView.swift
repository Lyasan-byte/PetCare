//
//  BackgroundView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class BackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(
        backgroundColor: UIColor = .white,
        cornerRadius: CGFloat = 35
    ) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 35
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
