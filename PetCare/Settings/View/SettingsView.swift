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
    var onThemeSelected: ((SettingsTheme) -> Void)?
    var onLanguageSelected: ((SettingsLanguage) -> Void)?
    var onDeleteAccountTap: (() -> Void)?

    private let loader = UIActivityIndicatorView(style: .medium)
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.45)
        view.isHidden = true
        return view
    }()
    private let scrollView = ScrollView()
    private let contentView = UIView()

    private let settingsCard = BackgroundView(
        backgroundColor: .tertiarySystemBackground,
        cornerRadius: 34
    )
    private let notificationsHeaderView = SettingsSectionHeaderView()
    private let primaryNotificationToggleView = SettingsPrimaryNotificationToggleView()
    private let notificationOptionsView = SettingsNotificationOptionsView()
    private let notificationsDividerView = UIView()
    private let appearanceHeaderView = SettingsSectionHeaderView()
    private let appearanceOptionsView = SettingsAppearanceOptionsView()
    private let appearanceDividerView = UIView()
    private let accountHeaderView = SettingsSectionHeaderView()
    private let deleteAccountRow = SettingsAccountActionRowView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func render(displayData: SettingsDisplayData) {
        applyLocalizedTexts()
        primaryNotificationToggleView.render(isOn: displayData.isNotificationsEnabled)
        notificationOptionsView.render(displayData: displayData)
        appearanceOptionsView.render(displayData: displayData)
        setDeleting(displayData.isDeletingAccount)
    }

    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(loadingOverlay)
        loadingOverlay.addSubview(loader)
        scrollView.addSubview(contentView)

        [
            settingsCard
        ].forEach(contentView.addSubview)

        settingsCard.addSubview(notificationsHeaderView)
        settingsCard.addSubview(primaryNotificationToggleView)
        settingsCard.addSubview(notificationOptionsView)
        settingsCard.addSubview(notificationsDividerView)
        settingsCard.addSubview(appearanceHeaderView)
        settingsCard.addSubview(appearanceOptionsView)
        settingsCard.addSubview(appearanceDividerView)
        settingsCard.addSubview(accountHeaderView)
        settingsCard.addSubview(deleteAccountRow)
    }

    private func setupLayout() {
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        notificationsDividerView.translatesAutoresizingMaskIntoConstraints = false
        appearanceDividerView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            settingsCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            settingsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            settingsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            settingsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            notificationsHeaderView.topAnchor.constraint(equalTo: settingsCard.topAnchor, constant: 20),
            notificationsHeaderView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            notificationsHeaderView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),

            primaryNotificationToggleView.topAnchor.constraint(equalTo: notificationsHeaderView.bottomAnchor, constant: 16),
            primaryNotificationToggleView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            primaryNotificationToggleView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),

            notificationOptionsView.topAnchor.constraint(equalTo: primaryNotificationToggleView.bottomAnchor, constant: 12),
            notificationOptionsView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 28),
            notificationOptionsView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),

            notificationsDividerView.topAnchor.constraint(equalTo: notificationOptionsView.bottomAnchor, constant: 16),
            notificationsDividerView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            notificationsDividerView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),
            notificationsDividerView.heightAnchor.constraint(equalToConstant: 1),

            appearanceHeaderView.topAnchor.constraint(equalTo: notificationsDividerView.bottomAnchor, constant: 16),
            appearanceHeaderView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            appearanceHeaderView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),

            appearanceOptionsView.topAnchor.constraint(equalTo: appearanceHeaderView.bottomAnchor, constant: 16),
            appearanceOptionsView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            appearanceOptionsView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),

            appearanceDividerView.topAnchor.constraint(equalTo: appearanceOptionsView.bottomAnchor, constant: 16),
            appearanceDividerView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            appearanceDividerView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),
            appearanceDividerView.heightAnchor.constraint(equalToConstant: 1),

            accountHeaderView.topAnchor.constraint(equalTo: appearanceDividerView.bottomAnchor, constant: 16),
            accountHeaderView.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 18),
            accountHeaderView.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -18),

            deleteAccountRow.topAnchor.constraint(equalTo: accountHeaderView.bottomAnchor, constant: 16),
            deleteAccountRow.leadingAnchor.constraint(equalTo: settingsCard.leadingAnchor, constant: 22),
            deleteAccountRow.trailingAnchor.constraint(equalTo: settingsCard.trailingAnchor, constant: -22),
            deleteAccountRow.bottomAnchor.constraint(equalTo: settingsCard.bottomAnchor, constant: -20)
        ])
    }

    private func configure() {
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .clear
        loader.hidesWhenStopped = true

        settingsCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        settingsCard.layer.shadowOpacity = 1
        settingsCard.layer.shadowOffset = CGSize(width: 0, height: 14)
        settingsCard.layer.shadowRadius = 28

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

        appearanceOptionsView.onThemeSelected = { [weak self] theme in
            self?.onThemeSelected?(theme)
        }
        appearanceOptionsView.onLanguageSelected = { [weak self] language in
            self?.onLanguageSelected?(language)
        }

        deleteAccountRow.onTap = { [weak self] in
            self?.onDeleteAccountTap?()
        }

        notificationsDividerView.backgroundColor = Asset.petLightGray.color.withAlphaComponent(0.85)
        appearanceDividerView.backgroundColor = Asset.petLightGray.color.withAlphaComponent(0.85)
    }

    private func applyLocalizedTexts() {
        notificationsHeaderView.configure(
            symbolName: "bell.fill",
            title: NSLocalizedString("settings.notifications.title", comment: ""),
            iconColor: Asset.accentColor.color,
            circleColor: Asset.petGreenAction.color
        )
        primaryNotificationToggleView.configure(
            title: NSLocalizedString("settings.notifications.all", comment: "")
        )
        notificationOptionsView.refreshLocalizedTexts()

        appearanceHeaderView.configure(
            symbolName: "paintpalette.fill",
            title: NSLocalizedString("settings.appearance.title", comment: ""),
            iconColor: Asset.purpleAccent.color,
            circleColor: Asset.petPurpleAction.color
        )

        accountHeaderView.configure(
            symbolName: "person",
            title: NSLocalizedString("settings.account.title", comment: ""),
            iconColor: Asset.pinkAccent.color,
            circleColor: Asset.petPinkAction.color
        )
        deleteAccountRow.configure(
            title: NSLocalizedString("settings.account.delete", comment: "")
        )
    }

    private func setDeleting(_ isDeleting: Bool) {
        loadingOverlay.isHidden = !isDeleting

        if isDeleting {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }

        scrollView.isUserInteractionEnabled = !isDeleting
        deleteAccountRow.isEnabled = !isDeleting
        deleteAccountRow.alpha = isDeleting ? 0.6 : 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
