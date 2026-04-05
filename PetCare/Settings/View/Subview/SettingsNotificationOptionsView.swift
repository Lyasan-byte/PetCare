//
//  SettingsNotificationOptionsView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsNotificationOptionsView: UIView {
    var onGroomingToggle: ((Bool) -> Void)?
    var onVeterinarianToggle: ((Bool) -> Void)?
    var onGeneralRemindersToggle: ((Bool) -> Void)?

    private let groomingRow = SettingsNotificationRowView()
    private let veterinarianRow = SettingsNotificationRowView()
    private let generalRemindersRow = SettingsNotificationRowView()

    private lazy var detailsStack = VStack(
        spacing: 10,
        arrangedSubviews: [groomingRow, veterinarianRow, generalRemindersRow]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func render(state: SettingsState) {
        groomingRow.render(
            isOn: state.isGroomingEnabled,
            isEnabled: state.isNotificationsEnabled
        )
        veterinarianRow.render(
            isOn: state.isVeterinarianEnabled,
            isEnabled: state.isNotificationsEnabled
        )
        generalRemindersRow.render(
            isOn: state.isGeneralRemindersEnabled,
            isEnabled: state.isNotificationsEnabled
        )
    }

    private func setupHierarchy() {
        addSubview(detailsStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailsStack.topAnchor.constraint(equalTo: topAnchor),
            detailsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        groomingRow.configure(
            symbolName: "scissors",
            title: NSLocalizedString("settings.notifications.grooming", comment: ""),
            onTintColor: Asset.petGreen.color
        )
        veterinarianRow.configure(
            symbolName: "cross.case",
            title: NSLocalizedString("settings.notifications.veterinarian", comment: ""),
            onTintColor: Asset.petGreen.color
        )
        generalRemindersRow.configure(
            symbolName: "calendar",
            title: NSLocalizedString("settings.notifications.general_reminders", comment: ""),
            onTintColor: Asset.petGreen.color
        )

        groomingRow.onToggle = { [weak self] isEnabled in
            self?.onGroomingToggle?(isEnabled)
        }
        veterinarianRow.onToggle = { [weak self] isEnabled in
            self?.onVeterinarianToggle?(isEnabled)
        }
        generalRemindersRow.onToggle = { [weak self] isEnabled in
            self?.onGeneralRemindersToggle?(isEnabled)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
