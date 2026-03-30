//
//  PetInfoRowView.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit

final class PetInfoRowView: UIView {
    private let background = BackgroundView(cornerRadius: 19)
    private let text = TextLabel(font: .systemFont(ofSize: 12.5, weight: .medium))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    func setData(info: String) {
        text.text = info
    }
    
    private func setupHierarchy() {
        addSubview(background)
        background.addSubview(text)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            text.topAnchor.constraint(equalTo: background.topAnchor, constant: 5),
            text.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            text.topAnchor.constraint(equalTo: background.bottomAnchor, constant: -5)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
