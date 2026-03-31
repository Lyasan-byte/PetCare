//
//  ScreenTitle.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class TextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(
        font: UIFont = .systemFont(ofSize: 21, weight: .bold),
        text: String = "",
        textColor: UIColor = .label,
        textAlignment: NSTextAlignment = .center
    ) {
        self.init(frame: .zero)
        self.font = font
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
