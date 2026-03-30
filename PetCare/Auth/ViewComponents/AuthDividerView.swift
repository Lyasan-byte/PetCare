//
//  AuthDividerView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 27.03.2026.
//

import Foundation
import UIKit

final class AuthDividerView: UIView {

    private let leftLine = UIView()
    private let rightLine = UIView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String) {
        titleLabel.text = text
    }

    private func setup() {
        leftLine.backgroundColor = Asset.petGray.color.withAlphaComponent(0.5)
        rightLine.backgroundColor = Asset.petGray.color.withAlphaComponent(0.5)

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = Asset.petGray.color
        titleLabel.textAlignment = .center

        [leftLine, rightLine, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            leftLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16),
            leftLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),

            rightLine.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            rightLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),

            heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
