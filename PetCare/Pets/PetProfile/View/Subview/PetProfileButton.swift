//
//  PetProfileButton.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileButton: UIView {
    var onTap: (() -> Void)?

    var background = BackgroundView(cornerRadius: 20)
    var buttonText = TextLabel(font: .systemFont(ofSize: 16, weight: .semibold))

    var button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    convenience init(text: String, image: String, textColor: UIColor, backgroundColor: UIColor) {
        self.init(frame: .zero)

        button.backgroundColor = backgroundColor

        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let symbolImage = UIImage(systemName: image, withConfiguration: config)
        button.setImage(symbolImage, for: .normal)
        button.tintColor = textColor

        button.setTitle(text, for: .normal)
    }

    private func setupHierarchy() {
        addSubview(button)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),

            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(didButtonTap), for: .touchUpInside)
    }

    @objc private func didButtonTap() {
        onTap?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
