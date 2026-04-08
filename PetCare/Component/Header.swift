//
//  Header.swift
//  PetCare
//
//  Created by Ляйсан on 2/4/26.
//

import UIKit

final class Header: UIView {
    var titleIcon = ImageView(tintColor: Asset.accentColor.color)

    var screenTitle = TextLabel(
        font: .systemFont(ofSize: 20, weight: .semibold),
        textColor: Asset.accentColor.color,
        textAlignment: .left
    )
    lazy var headerStack = HStack(spacing: 10, arrangedSubviews: [titleIcon, screenTitle])

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init(icon: String, text: String) {
        self.init(frame: .zero)
        titleIcon.image = UIImage(systemName: icon)
        screenTitle.text = text
    }

    private func setupHierarchy() {
        addSubview(headerStack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleIcon.widthAnchor.constraint(equalToConstant: 25),
            titleIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
