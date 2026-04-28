//
//  SkipButton.swift
//  PetCare
//
//  Created by Ляйсан on 19/4/26.
//

import UIKit

final class SkipButton: UIButton {
    var onTap: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setTitle(L10n.WelcomeOnboarding.SkipButton.title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        setTitleColor(Asset.petGray.color, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc private func didTap() {
        onTap?()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
