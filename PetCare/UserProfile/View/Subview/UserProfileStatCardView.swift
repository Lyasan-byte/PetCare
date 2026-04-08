//
//  UserProfileStatCardView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit

final class UserProfileStatCardView: UIView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(value: String, title: String, backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        valueLabel.text = value
        valueLabel.textColor = textColor
        titleLabel.text = title.uppercased()
        titleLabel.textColor = textColor.withAlphaComponent(0.65)
    }

    private func setupHierarchy() {
        addSubview(valueLabel)
        addSubview(titleLabel)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 142),

            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        ])
    }

    private func configure() {
        layer.cornerRadius = 34
        valueLabel.font = .systemFont(ofSize: 36, weight: .bold)
        valueLabel.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.addCharacterSpacing(1.8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UILabel {
    func addCharacterSpacing(_ value: CGFloat) {
        guard let text else { return }

        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(
            .kern,
            value: value,
            range: NSRange(location: 0, length: attributedText.length)
        )
        self.attributedText = attributedText
    }
}
