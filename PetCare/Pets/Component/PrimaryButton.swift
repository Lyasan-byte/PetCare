//
//  PrimaryButton.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//
import UIKit

final class PrimaryButton: UIButton {
    var onTap: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title: String, backgroundColor: UIColor = Asset.accentColor.color, textColor: UIColor = Asset.textGreen.color) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
 
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 26
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addTarget(self, action: #selector(didButtonTap), for: .touchUpInside)
    }
    
    @objc private func didButtonTap() {
        onTap?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
