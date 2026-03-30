//
//  PetIconStatusView.swift
//  PetCare
//
//  Created by Ляйсан on 26/3/26.
//

import UIKit

extension CircleIconView {
    convenience init(status: PetIconStatus, circleSize: CGFloat = 50, iconSize: CGFloat = 35) {
        self.init(frame: .zero)
        configure(status: status, circleSize: circleSize, iconSize: iconSize)
    }

    func configure(status: PetIconStatus, circleSize: CGFloat = 50, iconSize: CGFloat = 35) {
        configure(
            symbolName: status.icon,
            iconColor: status.iconColor,
            circleColor: status.backgroundColor,
            circleSize: circleSize,
            iconSize: iconSize
        )
    }
}
