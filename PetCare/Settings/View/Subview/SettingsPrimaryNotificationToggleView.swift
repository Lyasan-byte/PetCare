//
//  SettingsPrimaryNotificationToggleView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsPrimaryNotificationToggleView: UIView {
    var onToggle: ((Bool) -> Void)?

    private let titleLabel = UILabel()
    private let switchControl = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    func render(isOn: Bool) {
        guard switchControl.isOn != isOn else { return }
        switchControl.setOn(isOn, animated: window != nil)
    }

    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(switchControl)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 72),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: switchControl.leadingAnchor, constant: -12),

            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configure() {
        backgroundColor = UIColor { traitCollection in
            let baseColor = Asset.petLightGray.color(compatibleWith: traitCollection)
            let alpha: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.92 : 0.35
            return baseColor.withAlphaComponent(alpha)
        }
        layer.cornerRadius = 24

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label

        switchControl.onTintColor = Asset.primaryGreen.color
        switchControl.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        switchControl.addAction(
            UIAction { [weak self, weak switchControl] _ in
                self?.onToggle?(switchControl?.isOn ?? false)
            },
            for: .valueChanged
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
