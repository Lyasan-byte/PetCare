//
//  MiniGameIdleOverlayView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13/04/26.
//

import UIKit

final class MiniGameIdleOverlayView: UIView {
    private let tapCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 66
        view.layer.borderWidth = 2
        view.layer.borderColor = Asset.primaryGreen.color.withAlphaComponent(0.2).cgColor
        view.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        return view
    }()

    private let tapIcon: ImageView = {
        let imageView = ImageView(tintColor: Asset.primaryGreen.color)
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        imageView.image = UIImage(systemName: "hand.tap", withConfiguration: config)
        return imageView
    }()

    private let titleLabel = TextLabel(
        font: .systemFont(ofSize: 18, weight: .semibold),
        text: NSLocalizedString("mini.game.field.tap_to_jump", comment: ""),
        textColor: Asset.textGray.color
    )
    private let subtitleLabel = TextLabel(
        font: .systemFont(ofSize: 14, weight: .medium),
        textColor: Asset.petGray.color
    )

    private lazy var stack = VStack(
        spacing: 14,
        arrangedSubviews: [
            tapCircleView,
            titleLabel,
            subtitleLabel
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }

    func setPetSelected(_ isPetSelected: Bool) {
        subtitleLabel.text = isPetSelected ? nil : NSLocalizedString("mini.game.field.no_pet", comment: "")
        subtitleLabel.isHidden = isPetSelected
    }

    private func setupHierarchy() {
        addSubview(stack)
        tapCircleView.addSubview(tapIcon)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tapCircleView.widthAnchor.constraint(equalToConstant: 132),
            tapCircleView.heightAnchor.constraint(equalToConstant: 132),

            tapIcon.centerXAnchor.constraint(equalTo: tapCircleView.centerXAnchor),
            tapIcon.centerYAnchor.constraint(equalTo: tapCircleView.centerYAnchor),
            tapIcon.widthAnchor.constraint(equalToConstant: 42),
            tapIcon.heightAnchor.constraint(equalToConstant: 42),

            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
