//
//  OnboardingPageIndicatorView.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class OnboardingPageIndicatorView: UIView {
    private let stack = HStack(spacing: 10, alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    convenience init(currentPage: Int, totalPages: Int) {
        self.init(frame: .zero)
        setPages(currentPage: currentPage, totalPages: totalPages)
    }

    func setPages(currentPage: Int, totalPages: Int) {
        stack.arrangedSubviews.forEach { view in
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for index in 0..<totalPages {
            let indicator = UIView()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.backgroundColor = index == currentPage
                ? Asset.primaryGreen.color
            : Asset.petGray.color
            indicator.layer.cornerRadius = 4

            NSLayoutConstraint.activate([
                indicator.heightAnchor.constraint(equalToConstant: 8),
                indicator.widthAnchor.constraint(equalToConstant: index == currentPage ? 26 : 8)
            ])

            stack.addArrangedSubview(indicator)
        }
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
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
