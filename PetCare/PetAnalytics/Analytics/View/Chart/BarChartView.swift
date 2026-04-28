//
//  BarChartView.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import UIKit

final class BarChartView: UIView {
    private let stack = UIStackView()
    private let scale = BarChartScaleView()
    
    private var columnViews: [BarChartColumnView] = []
    private var stackLeadingConstraint: NSLayoutConstraint?

    private var valueStyle: BarChartValueStyle = .distance {
        didSet {
            stackLeadingConstraint?.constant = stackLeadingInset
        }
    }

    private var stackLeadingInset: CGFloat {
        valueStyle == .distance ? 30 : 45
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(scale)
        addSubview(stack)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let stackLeadingConstraint = stack.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: stackLeadingInset
        )
        self.stackLeadingConstraint = stackLeadingConstraint
        
        NSLayoutConstraint.activate([
            scale.topAnchor.constraint(equalTo: stack.topAnchor, constant: 6),
            scale.leadingAnchor.constraint(equalTo: leadingAnchor),
            scale.trailingAnchor.constraint(equalTo: trailingAnchor),
            scale.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: topAnchor),
            stackLeadingConstraint,
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(items: [BarChartItem], color: UIColor = Asset.accentColor.color, style: BarChartValueStyle) {
        self.valueStyle = style
        rebuildColumnsIfNeeded(count: items.count)
        
        let maxValue = items.map(\.value).max() ?? 0
        let mid1 = maxValue / 3
        let mid2 = 2 * maxValue / 3
        
        scale.configure(values: [maxValue, mid2, mid1, 0], style: style)
        
        for (index, item) in items.enumerated() {
            columnViews[index]
                .configure(
                    title: item.title,
                    value: item.value,
                    maxValue: maxValue,
                    color: color
                )
        }
    }
    
    private func rebuildColumnsIfNeeded(count: Int) {
        guard columnViews.count != count else { return }
        
        columnViews.forEach { $0.removeFromSuperview() }
        columnViews.removeAll()
        
        for _ in 0..<count {
            let column = BarChartColumnView()
            column.translatesAutoresizingMaskIntoConstraints = false
            columnViews.append(column)
            stack.addArrangedSubview(column)
        }
    }
    
    private func configure() {
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
    }
}
