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
    
    convenience init(contentMode: UIView.ContentMode = .scaleAspectFit, tintColor: UIColor = Asset.primaryGreen.color) {
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.tintColor = tintColor
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
