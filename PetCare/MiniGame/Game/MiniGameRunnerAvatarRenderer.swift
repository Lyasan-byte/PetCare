//
//  MiniGameRunnerAvatarRenderer.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 13/04/26.
//

import UIKit

extension UIImage {
    func circularMiniGameAvatar(
        size: CGSize,
        borderColor: UIColor = Asset.accentColor.color,
        borderWidth: CGFloat = 3
    ) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = false

        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let insetRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)

            let path = UIBezierPath(ovalIn: insetRect)
            path.addClip()

            let imageSize = self.size
            let scale = max(insetRect.width / imageSize.width, insetRect.height / imageSize.height)
            let drawSize = CGSize(
                width: imageSize.width * scale,
                height: imageSize.height * scale
            )
            let drawRect = CGRect(
                x: insetRect.midX - drawSize.width / 2,
                y: insetRect.midY - drawSize.height / 2,
                width: drawSize.width,
                height: drawSize.height
            )
            draw(in: drawRect)

            borderColor.setStroke()
            path.lineWidth = borderWidth
            path.stroke()
        }
    }
}
