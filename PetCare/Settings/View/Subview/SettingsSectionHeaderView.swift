//
//  SettingsSectionHeaderView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import UIKit

final class SettingsSectionHeaderView: UIView {
    private let iconView = CircleIconView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(
        symbolName: String,
        title: String,
        iconColor: UIColor,
        circleColor: UIColor
    ) {
        iconView.configure(
            symbolName: symbolName,
            iconColor: iconColor,
            circleColor: circleColor,
            circleSize: 56,
            iconSize: 20,
            weight: .semibold
        )
        titleLabel.text = title
    }

    private func setupHierarchy() {
        addSubview(iconView)
        addSubview(titleLabel)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func configure() {
        backgroundColor = .clear
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
