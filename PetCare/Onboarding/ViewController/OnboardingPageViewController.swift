//
//  OnboardingPageViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 19/4/26.
//

import UIKit

final class OnboardingPageViewController<ContentView: OnboardingPageView>: UIViewController {
    var onSkipTap: (() -> Void)?
    var onNextTap: (() -> Void)?

    private let contentView: ContentView

    init(contentView: ContentView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        bindActions()
    }

    private func setupAppearance() {
        view.addSubview(contentView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindActions() {
        contentView.onSkipTap = { [weak self] in
            self?.onSkipTap?()
        }

        contentView.onNextTap = { [weak self] in
            self?.onNextTap?()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
