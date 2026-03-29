//
//  AuthHeaderView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 27.03.2026.
//

import Foundation
import UIKit

final class AuthHeaderView: UIView {

    private let logoImageView = UIImageView()
    private let brandLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    private func setup() {
        backgroundColor = .clear

        logoImageView.image = UIImage(systemName: "pawprint.fill")
        logoImageView.tintColor = Asset.accentColor.color
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setContentHuggingPriority(.required, for: .horizontal)

        brandLabel.text = "Pet Care"
        brandLabel.font = .systemFont(ofSize: 24, weight: .bold)
        brandLabel.textColor = Asset.accentColor.color

        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = Asset.petGray.color
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        let brandStack = UIStackView(arrangedSubviews: [logoImageView, brandLabel])
        brandStack.axis = .horizontal
        brandStack.spacing = 8
        brandStack.alignment = .center
        brandStack.translatesAutoresizingMaskIntoConstraints = false
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 8
        titleStack.alignment = .center
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        let contentStack = UIStackView(arrangedSubviews: [brandStack, titleStack])
        contentStack.axis = .vertical
        contentStack.spacing = 44
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 34),
            logoImageView.heightAnchor.constraint(equalToConstant: 34),

            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

