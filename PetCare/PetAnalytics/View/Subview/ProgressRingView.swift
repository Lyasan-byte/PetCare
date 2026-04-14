//
//  ProgressRingView.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class ProgressRingView: UIView {
    private let ringBackgroundLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = Asset.lightGreen.color.cgColor
        shape.lineCap = .round
        shape.lineWidth = 10
        return shape
    }()
    
    private let progressLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = Asset.accentColor.color.cgColor
        shape.lineCap = .round
        shape.lineWidth = 10
        shape.strokeEnd = 0
        return shape
    }()
    
    private let valueTitle = TextLabel(
        font: .systemFont(
            ofSize: 18,
            weight: .semibold
        ),
        textAlignment: .left
    )
    
    private let valueSubtitle = TextLabel(
        font: .systemFont(
            ofSize: 18,
            weight: .semibold
        ),
        textAlignment: .left
    )
    
    private lazy var infoStack = VStack(arrangedSubviews: [valueTitle, valueSubtitle])
    
    private var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = max(0, min(progress, 1))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init(subtitle: String = "") {
        self.init(frame: .zero)
        self.valueTitle.text = subtitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    private func setupHierarchy() {
        layer.addSublayer(ringBackgroundLayer)
        layer.addSublayer(progressLayer)
        addSubview(infoStack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + CGFloat.pi * 2
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        ringBackgroundLayer.path = path.cgPath
        ringBackgroundLayer.frame = bounds
        
        progressLayer.path = path.cgPath
        progressLayer.frame = bounds
    }
    
    func configure(goal: String, actualValue: String, progress: CGFloat) {
        valueTitle.text = "\(actualValue)/\(goal)"
        self.progress = progress
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
