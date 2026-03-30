//
//  ScrollView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

final class ScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
