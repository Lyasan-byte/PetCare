//
//  GradientView.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        configure()
        registerTraitChanges()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.insertSublayer(gradientLayer, at: 0)

        updateGradientColors()
        gradientLayer.locations = [0.0, 0.65, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [
            UIColor.secondarySystemBackground.resolvedColor(with: traitCollection).cgColor,
            UIColor.secondarySystemBackground.resolvedColor(with: traitCollection).cgColor,
            UIColor.backgroundGreen.resolvedColor(with: traitCollection).cgColor
        ]
    }

    private func registerTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { (self: Self, _) in
            self.updateGradientColors()
        }
    }
}
