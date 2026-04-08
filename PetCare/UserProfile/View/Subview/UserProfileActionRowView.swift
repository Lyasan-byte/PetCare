//
//  UserProfileActionRowView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit

final class UserProfileActionRowView: UIControl {
    struct IconConfiguration {
        let name: String
        let tintColor: UIColor
        let backgroundColor: UIColor
    }

    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let textStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(
        icon: IconConfiguration,
        title: String,
        subtitle: String,
        titleColor: UIColor
    ) {
        iconImageView.image = UIImage(systemName: icon.name)
        iconImageView.tintColor = icon.tintColor
        iconContainer.backgroundColor = icon.backgroundColor
        titleLabel.text = title
        titleLabel.textColor = titleColor
        subtitleLabel.text = subtitle
    }

    private func setupHierarchy() {
        addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        addSubview(arrowImageView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 86),

            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 54),
            iconContainer.heightAnchor.constraint(equalToConstant: 54),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),

            textStackView.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 14),
            textStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -12),

            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configure() {
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 40
        layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 12)
        layer.shadowRadius = 24
        layer.borderWidth = 0.3
        layer.borderColor = (Asset.petGray.color.withAlphaComponent(0.3)).cgColor

        [
            iconContainer,
            iconImageView,
            textStackView,
            titleLabel,
            subtitleLabel,
            arrowImageView
        ].forEach { $0.isUserInteractionEnabled = false }

        iconContainer.layer.cornerRadius = 27

        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        iconImageView.preferredSymbolConfiguration = iconConfig
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.alignment = .leading

        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.numberOfLines = 1
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = Asset.petGray.color
        subtitleLabel.numberOfLines = 2

        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = Asset.petGray.color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
