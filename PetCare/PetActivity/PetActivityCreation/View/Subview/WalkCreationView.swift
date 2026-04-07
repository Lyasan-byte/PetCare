//
//  WalkDeatilsView.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit

final class WalkDeatilsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
//            background.topAnchor.constraint(equalTo: topAnchor),
//            background.leadingAnchor.constraint(equalTo: leadingAnchor),
//            background.trailingAnchor.constraint(equalTo: trailingAnchor),
//            background.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

