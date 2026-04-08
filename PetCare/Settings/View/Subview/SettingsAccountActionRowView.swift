//
//  SettingsAccountActionRowView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsAccountActionRowView: UIControl {
    var onTap: (() -> Void)?

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    private func setupHierarchy() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(chevronImageView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),

            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),

            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configure() {
        backgroundColor = .clear

        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        iconImageView.preferredSymbolConfiguration = iconConfig
        iconImageView.image = UIImage(systemName: "trash.square")
        iconImageView.tintColor = Asset.petGray.color

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Asset.petGray.color

        let chevronConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        chevronImageView.preferredSymbolConfiguration = chevronConfig
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = Asset.petGray.color

        addAction(
            UIAction { [weak self] _ in
                self?.onTap?()
            },
            for: .touchUpInside
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
