//
//  SettingsNotificationOptionsView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsNotificationOptionsView: UIView {
    var onWalkToggle: ((Bool) -> Void)?
    var onGroomingToggle: ((Bool) -> Void)?
    var onVeterinarianToggle: ((Bool) -> Void)?

    private let walkRow = SettingsNotificationRowView()
    private let groomingRow = SettingsNotificationRowView()
    private let veterinarianRow = SettingsNotificationRowView()

    private lazy var detailsStack = VStack(
        spacing: 10,
        arrangedSubviews: [walkRow, groomingRow, veterinarianRow]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func render(displayData: SettingsDisplayData) {
        walkRow.render(
            isOn: displayData.isWalkEnabled,
            isEnabled: displayData.isNotificationsEnabled
        )
        groomingRow.render(
            isOn: displayData.isGroomingEnabled,
            isEnabled: displayData.isNotificationsEnabled
        )
        veterinarianRow.render(
            isOn: displayData.isVeterinarianEnabled,
            isEnabled: displayData.isNotificationsEnabled
        )
    }

    func refreshLocalizedTexts() {
        walkRow.updateTitle(NSLocalizedString("settings.notifications.walk", comment: ""))
        groomingRow.updateTitle(NSLocalizedString("settings.notifications.grooming", comment: ""))
        veterinarianRow.updateTitle(NSLocalizedString("settings.notifications.veterinarian", comment: ""))
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
        walkRow.configure(
            symbolName: "figure.walk",
            title: NSLocalizedString("settings.notifications.walk", comment: ""),
            onTintColor: Asset.petGreen.color
        )
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

        walkRow.onToggle = { [weak self] isEnabled in
            self?.onWalkToggle?(isEnabled)
        }
        groomingRow.onToggle = { [weak self] isEnabled in
            self?.onGroomingToggle?(isEnabled)
        }
        veterinarianRow.onToggle = { [weak self] isEnabled in
            self?.onVeterinarianToggle?(isEnabled)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
