//
//  AuthContainerView.swift
//  PetCare
//
//  Created by Codex on 01.04.2026.
//

import Foundation
import UIKit

final class AuthContainerView: UIView {

    private let headerView = AuthHeaderView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardView = UIView()
    private let headerBottomSpacing: CGFloat

    init(headerBottomSpacing: CGFloat) {
        self.headerBottomSpacing = headerBottomSpacing
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHeaderView(title: String, subtitle: String) {
        headerView.configure(title: title, subtitle: subtitle)
    }

    func addCardContentView(_ view: UIView) {
        cardView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            view.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            view.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }

    private func setup() {
        backgroundColor = .systemGroupedBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            headerView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: headerBottomSpacing),

            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        cardView.backgroundColor = Asset.authCardViewColor.color
        cardView.layer.cornerRadius = 40
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowRadius = 20
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
