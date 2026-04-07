//
//  SettingsSegmentedControlView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import UIKit

final class SettingsSegmentedControlView: UIView {
    var onSelectionChange: ((Int) -> Void)?

    private let segmentedControl = UISegmentedControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func configure(items: [String], selectedIndex: Int) {
        segmentedControl.removeAllSegments()

        for (index, item) in items.enumerated() {
            segmentedControl.insertSegment(withTitle: item, at: index, animated: false)
        }

        if !items.isEmpty {
            segmentedControl.selectedSegmentIndex = min(selectedIndex, items.count - 1)
        }
    }

    private func setupHierarchy() {
        addSubview(segmentedControl)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 38),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 152)
        ])
    }

    private func configure() {
        backgroundColor = .clear

        segmentedControl.selectedSegmentTintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .white
        }
        segmentedControl.backgroundColor = UIColor { traitCollection in
            let baseColor = Asset.petLightGray.color(compatibleWith: traitCollection)
            let alpha: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.7 : 0.35
            return baseColor.withAlphaComponent(alpha)
        }
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: Asset.petGray.color,
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
        ], for: .selected)

        segmentedControl.addTarget(self, action: #selector(handleSelection), for: .valueChanged)
    }

    @objc private func handleSelection() {
        onSelectionChange?(segmentedControl.selectedSegmentIndex)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
