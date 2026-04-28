//
//  PetCardBadge.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class PetCardBadge: UIView {
    private let background = BackgroundView()
    private let icon = ImageView()
    private let badgeText = TextLabel(font: .systemFont(ofSize: 16, weight: .medium))
    private lazy var contentStack = HStack(
        spacing: 5,
        alignment: .center,
        arrangedSubviews: [icon, badgeText]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init(
        backgroundColor: UIColor,
        color: UIColor,
        icon: String,
        text: String = "",
        font: UIFont = .systemFont(ofSize: 12, weight: .medium),
        shadow: UIColor = .clear,
        border: UIColor = .clear,
        height: CGFloat,
        iconSize: CGFloat = 18
    ) {
        self.init(frame: .zero)
        setData(
            backgroundColor: backgroundColor,
            color: color,
            icon: icon,
            text: text,
            font: font,
            shadow: shadow,
            border: border,
            iconSize: iconSize
        )
        setHeight(height)
        setCornerRadius(height: height)
    }

    private func setData(
        backgroundColor: UIColor,
        color: UIColor,
        icon: String,
        text: String,
        font: UIFont,
        shadow: UIColor,
        border: UIColor,
        iconSize: CGFloat
    ) {
        background.backgroundColor = backgroundColor
        background.layer.borderColor = border.cgColor
        background.layer.borderWidth = 2

        self.icon.setSymbol(icon, pointSize: iconSize, weight: .medium)
        self.icon.tintColor = color

        badgeText.text = text
        badgeText.font = font
        badgeText.textColor = color
        badgeText.lineBreakMode = .byTruncatingTail

        layer.shadowColor = shadow.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    func configure(activity: PetLastActivity, height: CGFloat, iconSize: CGFloat = 18) {
        setData(
            backgroundColor: activity.type.activityBackgroundColor,
            color: activity.type.color,
            icon: activity.type.badgeIcon,
            text: "\(activity.type.name.uppercased()) \(formatDate(activity.date))",
            font: .systemFont(ofSize: 10, weight: .medium),
            shadow: .clear,
            border: .clear,
            iconSize: iconSize
        )
        setHeight(height)
        setCornerRadius(height: height)
    }

    private func setHeight(_ height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    private func setCornerRadius(height: CGFloat) {
        background.layer.cornerRadius = height / 2
        background.clipsToBounds = true
    }

    func setText(text: String) {
        badgeText.text = text
    }

    func setShadow(color: UIColor = .label) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 12
        layer.masksToBounds = false
    }

    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(contentStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        badgeText.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 7),
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12),
            contentStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -7)
        ])
    }

    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEEE, d MMM"
        return dateFormatter.string(from: date).uppercased()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
