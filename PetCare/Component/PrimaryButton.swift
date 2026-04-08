//
//  PrimaryButton.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//
import UIKit

final class PrimaryButton: UIButton {
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(
        title: String,
        backgroundColor: UIColor = Asset.primaryGreen.color,
        textColor: UIColor = Asset.textGreen.color,
        shadowColor: UIColor = .clear
    ) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor

        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 10
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 26
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        addTarget(self, action: #selector(didButtonTap), for: .touchUpInside)
    }

    @objc private func didButtonTap() {
        onTap?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
