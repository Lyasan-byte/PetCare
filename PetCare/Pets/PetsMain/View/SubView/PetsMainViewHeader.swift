//
//  PetsMainViewHeader.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import UIKit

final class PetsViewHeader: UIView {
    var titleIcon: ImageView = {
        let imageView = ImageView()
        imageView.image = UIImage(systemName: "pawprint.fill")
        return imageView
    }()
    
    var screenTitle = TextLabel(font: .systemFont(ofSize: 24, weight: .semibold), text: L10n.Pets.Main.title, textColor: Asset.accentColor.color, textAlignment: .left)
    lazy var headerStack = HStack(spacing: 10, arrangedSubviews: [titleIcon, screenTitle])
    
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
        addSubview(headerStack)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleIcon.widthAnchor.constraint(equalToConstant: 25),
            titleIcon.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

