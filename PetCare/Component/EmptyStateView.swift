//
//  EmptyStateView.swift
//  PetCare
//
//  Created by Ляйсан on 29/3/26.
//

import UIKit

final class EmptyStateView: UIView {
    private let imageView = ImageView(tintColor: Asset.accentColor.color)
    private let title = TextLabel(font: .systemFont(ofSize: 16, weight: .semibold))
    private let subtitle = TextLabel(
        font: .systemFont(
            ofSize: 14,
            weight: .regular
        ),
        textColor: Asset.petGray.color
    )

    private lazy var stack = VStack(spacing: 10, arrangedSubviews: [imageView, title, subtitle])

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init(title: String, subtitle: String, image: String) {
        self.init(frame: .zero)
        self.title.text = title
        self.subtitle.text = subtitle
        self.imageView.image = UIImage(systemName: image)
    }

    private func setupHierarchy() {
        addSubview(stack)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
