//
//  AuthPrimaryButton.swift
//  PetCare
//
//  Created by Codex on 01.04.2026.
//

import Foundation
import UIKit

final class AuthPrimaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String) {
        let arrowImage = UIImage(systemName: "arrow.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )

        configuration = .filled()
        configuration?.title = title
        configuration?.image = arrowImage
        configuration?.imagePlacement = .trailing
        configuration?.imagePadding = 8
        configuration?.cornerStyle = .capsule
        configuration?.baseBackgroundColor = Asset.accentColor.color
        configuration?.baseForegroundColor = .white
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        layer.cornerRadius = 28
        clipsToBounds = true
    }
}
