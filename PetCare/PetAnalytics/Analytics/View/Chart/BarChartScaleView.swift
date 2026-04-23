//
//  BarChartScaleView.swift
//  PetCare
//
//  Created by Ляйсан on 16/4/26.
//

import UIKit

final class BarChartScaleView: UIView {
    private let scaleLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 1
        view.backgroundColor = Asset.petGray.color.withAlphaComponent(0.7)
        return view
    }()
    
    private lazy var valuesStack = VStack(
        spacing: 0,
        distribution: .equalSpacing
    )
    
    private lazy var contentStack = HStack(
        spacing: 4,
        alignment: .leading,
        arrangedSubviews: [
            valuesStack,
            scaleLine
        ]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        addSubview(contentStack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        scaleLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            valuesStack.heightAnchor.constraint(equalToConstant: 120),
            scaleLine.widthAnchor.constraint(equalToConstant: 0.3),
            scaleLine.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configure(values: [Double]) {
        valuesStack.arrangedSubviews.forEach {
            valuesStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        values.forEach { value in
            let label = TextLabel(
                font: .systemFont(ofSize: 10, weight: .regular),
                text: formatValue(value),
                textColor: Asset.petGray.color.withAlphaComponent(0.7),
                textAlignment: .left
            )
            valuesStack.addArrangedSubview(label)
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
