//
//  AuthTextFieldView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 27.03.2026.
//

import Foundation
import UIKit

final class AuthTextFieldView: UIView {

    private let titleLabel = UILabel()
    let textField = UITextField()
    private let containerView = UIView()

    init(title: String, placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        setup(title: title, placeholder: placeholder, isSecure: isSecure)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String, placeholder: String, isSecure: Bool) {
        backgroundColor = .clear

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = Asset.petGray.color

        containerView.backgroundColor = Asset.petLightGray.color
        containerView.layer.cornerRadius = 26

        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .label
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        if !isSecure {
            textField.keyboardType = .emailAddress
        }

        [titleLabel, containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        textField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 52),

            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
