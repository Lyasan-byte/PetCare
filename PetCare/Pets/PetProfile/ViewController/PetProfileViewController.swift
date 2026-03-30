//
//  PetProfileViewController.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetProfileViewController: UIViewController {
    private let petProfileView = PetProfileView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(petProfileView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            petProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            petProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            
        ])
    }
    
}
