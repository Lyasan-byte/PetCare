//
//  CircleIconView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class CircleIconView: UIView {
    
    private let imageView = UIImageView()
    
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(
        symbolName: String = "star",
        iconColor: UIColor = Asset.pinkAccent.color,
        circleColor: UIColor = Asset.petPink.color,
        circleSize: CGFloat = 50,
        iconSize: CGFloat = 35,
        weight: UIImage.SymbolWeight = .regular
    ) {
        self.init(frame: .zero)
        configure(
            symbolName: symbolName,
            iconColor: iconColor,
            circleColor: circleColor,
            circleSize: circleSize,
            iconSize: iconSize,
            weight: weight
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(imageView)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        widthConstraint = widthAnchor.constraint(equalToConstant: 40)
        heightConstraint = heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            widthConstraint!,
            heightConstraint!,
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    func configure(
        symbolName: String,
        iconColor: UIColor,
        circleColor: UIColor,
        circleSize: CGFloat,
        iconSize: CGFloat,
        weight: UIImage.SymbolWeight = .regular
    ) {
        let config = UIImage.SymbolConfiguration(pointSize: iconSize, weight: weight)
        imageView.image = UIImage(systemName: symbolName, withConfiguration: config)
        imageView.tintColor = iconColor
        
        backgroundColor = circleColor
        
        widthConstraint?.constant = circleSize
        heightConstraint?.constant = circleSize
        
        layer.cornerRadius = circleSize / 2
    }
}
