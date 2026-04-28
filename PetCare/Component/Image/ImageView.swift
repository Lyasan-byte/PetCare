//
//  ImageView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class ImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(
        contentMode: UIView.ContentMode = .scaleAspectFit,
        tintColor: UIColor = Asset.accentColor.color,
        symbolPointSize: CGFloat? = nil,
        symbolWeight: UIImage.SymbolWeight = .regular
    ) {
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.tintColor = tintColor

        if let symbolPointSize {
            preferredSymbolConfiguration = UIImage.SymbolConfiguration(
                pointSize: symbolPointSize,
                weight: symbolWeight
            )
        }
    }

    func setSymbol(
        _ name: String,
        pointSize: CGFloat? = nil,
        weight: UIImage.SymbolWeight = .regular
    ) {
        if let pointSize {
            image = UIImage(
                systemName: name,
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: pointSize,
                    weight: weight
                )
            )
        } else {
            image = UIImage(systemName: name)
        }
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
