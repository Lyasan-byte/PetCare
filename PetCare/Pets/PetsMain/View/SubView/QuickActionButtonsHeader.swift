//
//  QuickActionButtonsHeader.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit

final class QuickActionButtonsHeader: UIView {
    var quickActionsTitle = TextLabel(
        text: L10n.Pets.Main.QuickActions.title
    )
    var quickActionsSubtitle = TextLabel(
        font: .systemFont(
            ofSize: 10,
            weight: .medium
        ),
        text: L10n.Pets.Main.QuickActions.subtitle,
        textColor: .systemGray
    )

    lazy var quickActionsTitleStack = HStack(
        spacing: 0,
        distribution: .equalSpacing,
        arrangedSubviews: [
            quickActionsTitle,
            quickActionsSubtitle
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    private func setupHierarchy() {
        addSubview(quickActionsTitleStack)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            quickActionsTitleStack.topAnchor.constraint(equalTo: topAnchor),
            quickActionsTitleStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            quickActionsTitleStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            quickActionsTitleStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
