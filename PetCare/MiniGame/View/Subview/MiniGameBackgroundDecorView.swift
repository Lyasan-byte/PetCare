//
//  MiniGameBackgroundDecorView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13/04/26.
//

import UIKit

final class MiniGameBackgroundDecorView: UIView {
    private enum Layout {
        static let visualGroundHeight: CGFloat = 74
        static let groundLineHeight: CGFloat = 3
    }

    private let bottomGlowView = UIView()
    private let groundLineView = UIView()

    private lazy var decorationViews: [ImageView] = (0..<3).map { _ in
        let imageView = ImageView(
            contentMode: .scaleAspectFit,
            tintColor: Asset.lightGreen.color.withAlphaComponent(0.3)
        )
        let config = UIImage.SymbolConfiguration(pointSize: 42, weight: .regular)
        imageView.image = UIImage(systemName: "tree.fill", withConfiguration: config)
        return imageView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        addSubview(bottomGlowView)
        addSubview(groundLineView)
        decorationViews.forEach(addSubview)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            bottomGlowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomGlowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomGlowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomGlowView.heightAnchor.constraint(equalToConstant: Layout.visualGroundHeight),

            groundLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groundLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            groundLineView.bottomAnchor.constraint(equalTo: bottomGlowView.topAnchor),
            groundLineView.heightAnchor.constraint(equalToConstant: Layout.groundLineHeight)
        ])

        let leftTree = decorationViews[0]
        let centerTree = decorationViews[1]
        let rightTree = decorationViews[2]

        NSLayoutConstraint.activate([
            leftTree.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftTree.bottomAnchor.constraint(equalTo: groundLineView.topAnchor, constant: -36),
            leftTree.widthAnchor.constraint(equalToConstant: 40),
            leftTree.heightAnchor.constraint(equalToConstant: 40),

            centerTree.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -24),
            centerTree.bottomAnchor.constraint(equalTo: groundLineView.topAnchor, constant: -28),
            centerTree.widthAnchor.constraint(equalToConstant: 64),
            centerTree.heightAnchor.constraint(equalToConstant: 64),

            rightTree.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            rightTree.bottomAnchor.constraint(equalTo: groundLineView.topAnchor, constant: -34),
            rightTree.widthAnchor.constraint(equalToConstant: 44),
            rightTree.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        bottomGlowView.translatesAutoresizingMaskIntoConstraints = false
        groundLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomGlowView.backgroundColor = Asset.petGreen.color.withAlphaComponent(0.14)
        groundLineView.backgroundColor = Asset.primaryGreen.color.withAlphaComponent(0.35)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
