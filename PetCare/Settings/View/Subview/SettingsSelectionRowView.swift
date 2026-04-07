//
//  SettingsSelectionRowView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsSelectionRowView: UIView {
    var onSelectionChange: ((Int) -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let segmentedControlView = SettingsSegmentedControlView()

    private lazy var labelsStack = VStack(
        spacing: 4,
        alignment: .leading,
        arrangedSubviews: [titleLabel, subtitleLabel]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(
        title: String,
        subtitle: String,
        items: [String],
        selectedIndex: Int
    ) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        segmentedControlView.configure(items: items, selectedIndex: selectedIndex)
    }

    private func setupHierarchy() {
        addSubview(labelsStack)
        addSubview(segmentedControlView)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: topAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: segmentedControlView.leadingAnchor, constant: -12),

            segmentedControlView.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControlView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configure() {
        backgroundColor = .clear
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .label

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = Asset.petGray.color
        subtitleLabel.numberOfLines = 2

        segmentedControlView.onSelectionChange = { [weak self] index in
            self?.onSelectionChange?(index)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
