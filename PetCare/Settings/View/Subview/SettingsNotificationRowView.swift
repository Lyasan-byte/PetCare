//
//  SettingsNotificationRowView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import UIKit

final class SettingsNotificationRowView: UIView {
    var onToggle: ((Bool) -> Void)?

    private let accentLine = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let switchControl = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(symbolName: String, title: String, onTintColor: UIColor) {
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        iconImageView.preferredSymbolConfiguration = iconConfig
        iconImageView.image = UIImage(systemName: symbolName)
        iconImageView.tintColor = Asset.petGray.color
        titleLabel.text = title
        switchControl.onTintColor = onTintColor
    }

    func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    func render(isOn: Bool, isEnabled: Bool) {
        if switchControl.isOn != isOn {
            switchControl.setOn(isOn, animated: window != nil)
        }
        switchControl.isEnabled = isEnabled
        iconImageView.alpha = isEnabled ? 1 : 0.45
        titleLabel.alpha = isEnabled ? 1 : 0.45
        accentLine.alpha = isEnabled ? 1 : 0.35
        alpha = isEnabled ? 1 : 0.82
    }

    private func setupHierarchy() {
        addSubview(accentLine)
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(switchControl)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),

            accentLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            accentLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            accentLine.widthAnchor.constraint(equalToConstant: 3),
            accentLine.heightAnchor.constraint(equalToConstant: 36),

            iconImageView.leadingAnchor.constraint(equalTo: accentLine.trailingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: switchControl.leadingAnchor, constant: -12),

            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configure() {
        backgroundColor = .clear
        accentLine.backgroundColor = Asset.petGreen.color
        accentLine.layer.cornerRadius = 1.5

        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = Asset.petGray.color

        switchControl.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        switchControl.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
    }

    @objc private func handleToggle() {
        onToggle?(switchControl.isOn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
