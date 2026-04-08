//
//  WalkCreationView.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class WalkCreationView: UIView {
    var onDistanceChange: ((String) -> Void)?
    var onActualDistanceChange: ((String) -> Void)?

    private let distanceGoal = TextFieldView(
        title: L10n.Pets.Activity.Walk.kmGoal,
        placeholder: L10n.Pets.Activity.Walk.KmGoal.placeholder,
        keyboardType: .decimalPad
    )

    private let actualDistance = TextFieldView(
        title: L10n.Pets.Activity.Walk.actual,
        placeholder: L10n.Pets.Activity.Walk.Actual.placeholder,
        keyboardType: .decimalPad
    )

    private lazy var contentStack = HStack(
        spacing: 10,
        distribution: .fillEqually,
        arrangedSubviews: [
            distanceGoal,
            actualDistance
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupActions()
    }

    convenience init() {
        self.init(frame: .zero)
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

    private func setupActions() {
        distanceGoal.onTextChanged = { [weak self] distanceString in
            self?.onDistanceChange?(distanceString)
        }

        actualDistance.onTextChanged = { [weak self] actualDistanceString in
            self?.onActualDistanceChange?(actualDistanceString)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
