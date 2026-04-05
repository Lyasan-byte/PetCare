//
//  SettingsView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsView: UIView {
    var onAllNotificationsToggle: ((Bool) -> Void)?
    var onGroomingToggle: ((Bool) -> Void)?
    var onVeterinarianToggle: ((Bool) -> Void)?
    var onGeneralRemindersToggle: ((Bool) -> Void)?

    private let scrollView = ScrollView()
    private let contentView = UIView()

    private let settingsCard = BackgroundView(
        backgroundColor: .tertiarySystemBackground,
        cornerRadius: 40
    )
    private let sectionHeader = SettingsSectionHeaderView()
    private let primaryNotificationToggleView = SettingsPrimaryNotificationToggleView()
    private let notificationOptionsView = SettingsNotificationOptionsView()
    private let dividerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func render(state: SettingsState) {
        primaryNotificationToggleView.render(isOn: state.isNotificationsEnabled)
        notificationOptionsView.render(state: state)
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            settingsCard
        ].forEach(contentView.addSubview)

        settingsCard.addSubview(sectionHeader)
        settingsCard.addSubview(primaryNotificationToggleView)
        settingsCard.addSubview(notificationOptionsView)
        settingsCard.addSubview(dividerView)
    }

    private func setupLayout() {
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false

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

            settingsCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            settingsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            settingsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            settingsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            sectionHeader.topAnchor.constraint(equalTo: settingsCard.topAnchor, constant: 24),
            sectionHeader.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 20),
            sectionHeader.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -20),

            primaryNotificationToggleView.topAnchor.constraint(equalTo: sectionHeader.bottomAnchor, constant: 20),
            primaryNotificationToggleView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 20),
            primaryNotificationToggleView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -20),

            notificationOptionsView.topAnchor.constraint(equalTo: primaryNotificationToggleView.bottomAnchor, constant: 16),
            notificationOptionsView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 32),
            notificationOptionsView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -20),

            dividerView.topAnchor.constraint(equalTo: notificationOptionsView.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.bottomAnchor.constraint(equalTo: settingsCard.bottomAnchor, constant: -24)
        ])
    }

    private func configure() {
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .clear

        settingsCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        settingsCard.layer.shadowOpacity = 1
        settingsCard.layer.shadowOffset = CGSize(width: 0, height: 14)
        settingsCard.layer.shadowRadius = 28

        sectionHeader.configure(
            symbolName: "bell.fill",
            title: NSLocalizedString("settings.notifications.title", comment: ""),
            iconColor: Asset.primaryGreen.color,
            circleColor: Asset.petGreen.color
        )

        primaryNotificationToggleView.configure(
            title: NSLocalizedString("settings.notifications.all", comment: "")
        )
        primaryNotificationToggleView.onToggle = { [weak self] isEnabled in
            self?.onAllNotificationsToggle?(isEnabled)
        }

        notificationOptionsView.onGroomingToggle = { [weak self] isEnabled in
            self?.onGroomingToggle?(isEnabled)
        }
        notificationOptionsView.onVeterinarianToggle = { [weak self] isEnabled in
            self?.onVeterinarianToggle?(isEnabled)
        }
        notificationOptionsView.onGeneralRemindersToggle = { [weak self] isEnabled in
            self?.onGeneralRemindersToggle?(isEnabled)
        }

        dividerView.backgroundColor = Asset.petLightGray.color.withAlphaComponent(0.85)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
