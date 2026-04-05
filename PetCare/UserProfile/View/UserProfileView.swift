//
//  UserProfileView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit

final class UserProfileView: UIView {
    let settingsRow = UserProfileActionRowView()
    let logoutRow = UserProfileActionRowView()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UserProfileHeaderView()
    private let statsView = UserProfileStatsView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(content: UserProfileContent, imageLoader: ImageLoader) {
        headerView.configure(content: content, imageLoader: imageLoader)
        statsView.configure(content: content)
    }

    func addEditTarget(_ target: Any?, action: Selector) {
        headerView.addEditTarget(target, action: action)
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            headerView,
            statsView,
            settingsRow,
            logoutRow
        ].forEach(contentView.addSubview)
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            statsView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            statsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            settingsRow.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 20),
            settingsRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            settingsRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            logoutRow.topAnchor.constraint(equalTo: settingsRow.bottomAnchor, constant: 14),
            logoutRow.leadingAnchor.constraint(equalTo: settingsRow.leadingAnchor),
            logoutRow.trailingAnchor.constraint(equalTo: settingsRow.trailingAnchor),
            logoutRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func configure() {
        backgroundColor = .secondarySystemBackground
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        settingsRow.configure(
            iconName: "gearshape.fill",
            iconTint: Asset.darkPink.color,
            iconBackground: Asset.petPinkAction.color.withAlphaComponent(0.3),
            title: NSLocalizedString("user.profile.settings.title", comment: ""),
            subtitle: NSLocalizedString("user.profile.settings.subtitle", comment: ""),
            titleColor: .label
        )

        logoutRow.configure(
            iconName: "rectangle.portrait.and.arrow.right",
            iconTint: Asset.redAccent.color,
            iconBackground: Asset.lightRed.color,
            title: NSLocalizedString("user.profile.logout.title", comment: ""),
            subtitle: "",
            titleColor: Asset.redAccent.color
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
