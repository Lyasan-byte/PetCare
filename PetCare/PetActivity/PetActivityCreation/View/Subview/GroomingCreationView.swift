//
//  GroomingCreationView.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class GroomingCreationView: UIView {
    var onChangeProcedure: ((Int) -> Void)?
    var onCostChange: ((String) -> Void)?

    private let procedurePicker = MenuPickerView(
        title: "PROCEDURE TYPE",
        options: GroomingProcedureType.allCases.map(\.title)
    )

    private let cost = TextFieldView(
        title: "COST",
        placeholder: "0.0",
        keyboardType: .decimalPad
    )

    private let duration = TextFieldView(
        title: "DURATION (MIN)",
        placeholder: "30",
        keyboardType: .decimalPad
    )

    private lazy var hStack = HStack(
        spacing: 10,
        distribution: .fillEqually,
        arrangedSubviews: [
            cost,
            duration
        ]
    )

    private lazy var contentStack = VStack(
        spacing: 16,
        arrangedSubviews: [
            procedurePicker,
            hStack
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupAction()
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

    private func setupAction() {
        procedurePicker.onChangeValue = { [weak self] index in
            self?.onChangeProcedure?(index)
        }

        cost.onTextChanged = { [weak self] costString in
            self?.onCostChange?(costString)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
