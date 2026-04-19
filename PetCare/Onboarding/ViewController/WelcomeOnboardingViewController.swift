//
//  WelcomeOnboardingViewController.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class WelcomeOnboardingViewController: UIViewController {
    private let welcomeOnboardingView = WelcomeOnboardingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
    }
    
    private func setupAppearance() {
        view.addSubview(welcomeOnboardingView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            welcomeOnboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeOnboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeOnboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeOnboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
