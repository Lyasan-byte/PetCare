//
//  SwitchOptionView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class SwitchOptionView: UIView {
    var onSwitchChange: ((Bool) -> Void)?
    private let background = BackgroundView(backgroundColor: .quaternarySystemFill)

    let icon = CircleIconView()

    let titleLabel = TextLabel(
        font: .systemFont(ofSize: 14, weight: .semibold),
        textAlignment: .left
    )

    let subtitleLabel = TextLabel(
        font: .systemFont(ofSize: 12, weight: .regular),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )

    lazy var textStack: UIStackView = {
        let stack = VStack(alignment: .leading, arrangedSubviews: [titleLabel, subtitleLabel])
        stack.spacing = 4
        return stack
    }()

    let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = Asset.primaryGreen.color
        switchControl.isOn = false
        return switchControl
    }()

    lazy var hstack: UIStackView = {
        let stack = HStack(alignment: .center, arrangedSubviews: [icon, textStack, switchControl])
        stack.spacing = 12
        stack.distribution = .fill
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    convenience init(
        title: String,
        subtitle: String,
        symbolName: String,
        iconColor: UIColor,
        circleColor: UIColor,
        circleSize: CGFloat,
        iconSize: CGFloat
    ) {
        self.init(frame: .zero)

        titleLabel.text = title
        subtitleLabel.text = subtitle

        icon.configure(
            symbolName: symbolName,
            iconColor: iconColor,
            circleColor: circleColor,
            circleSize: circleSize,
            iconSize: iconSize
        )
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(hstack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            hstack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            hstack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            hstack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            hstack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        textStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        switchControl.setContentHuggingPriority(.required, for: .horizontal)
        switchControl.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchControl.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
    }

    @objc private func switchDidChange() {
        onSwitchChange?(switchControl.isOn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
