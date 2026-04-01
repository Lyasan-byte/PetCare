//
//  AuthGoogleButton.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import Foundation
import UIKit

final class AuthGoogleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        configuration = .plain()
        backgroundColor = .white
        configuration?.cornerStyle = .capsule
        configuration?.imagePadding = 8
        layer.cornerRadius = 28
        layer.borderWidth = 1
        layer.borderColor = Asset.petGray.color.cgColor
        setTitle(NSLocalizedString("auth.google.button", comment: ""), for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        let googleImage = UIImage(named: "google_icon")
        let resizedImage = googleImage?.preparingThumbnail(of: CGSize(width: 20, height: 20))

        configuration?.image = resizedImage
        tintColor = nil
        semanticContentAttribute = .forceLeftToRight
        imageView?.contentMode = .scaleAspectFit
    }
}
