//
//  SettingsAppearanceOptionsView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsAppearanceOptionsView: UIView {
    var onThemeSelected: ((SettingsTheme) -> Void)?
    var onLanguageSelected: ((SettingsLanguage) -> Void)?

    private let themeRow = SettingsSelectionRowView()
    private let languageRow = SettingsSelectionRowView()

    private lazy var contentStack = VStack(
        spacing: 16,
        arrangedSubviews: [themeRow, languageRow]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func render(displayData: SettingsDisplayData) {
        themeRow.configure(
            title: NSLocalizedString("settings.appearance.theme.title", comment: ""),
            subtitle: NSLocalizedString("settings.appearance.theme.subtitle", comment: ""),
            items: SettingsTheme.allCases.map(\.localizedTitle),
            selectedIndex: SettingsTheme.allCases.firstIndex(of: displayData.theme) ?? 0
        )
        languageRow.configure(
            title: NSLocalizedString("settings.appearance.language.title", comment: ""),
            subtitle: NSLocalizedString("settings.appearance.language.subtitle", comment: ""),
            items: SettingsLanguage.allCases.map(\.localizedTitle),
            selectedIndex: SettingsLanguage.allCases.firstIndex(of: displayData.language) ?? 0
        )
    }

    private func setupHierarchy() {
        addSubview(contentStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure() {
        themeRow.onSelectionChange = { [weak self] index in
            guard SettingsTheme.allCases.indices.contains(index) else { return }
            self?.onThemeSelected?(SettingsTheme.allCases[index])
        }

        languageRow.onSelectionChange = { [weak self] index in
            guard SettingsLanguage.allCases.indices.contains(index) else { return }
            self?.onLanguageSelected?(SettingsLanguage.allCases[index])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
