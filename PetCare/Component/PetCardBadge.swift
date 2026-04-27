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
        spacing: 2,
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
        height: CGFloat
    ) {
        self.init(frame: .zero)
        setData(
            backgroundColor: backgroundColor,
            color: color,
            icon: icon,
            text: text,
            font: font,
            shadow: shadow
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
        shadow: UIColor
    ) {
        background.backgroundColor = backgroundColor
        self.icon.image = UIImage(systemName: icon)
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
    
    func configure(activity: PetLastActivity, height: CGFloat) {
        setData(
            backgroundColor: activity.type.activityBackgroundColor,
            color: activity.type.color,
            icon: activity.type.badgeIcon,
            text: "\(activity.type.name.uppercased()) \(formatDate(activity.date))",
            font: .systemFont(ofSize: 10, weight: .medium),
            shadow: .clear
        )
        setHeight(height)
        setCornerRadius(height: height)
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
            contentStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
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
