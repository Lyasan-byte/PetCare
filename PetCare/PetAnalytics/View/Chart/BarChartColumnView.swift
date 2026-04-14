//
//  BarChartColumnView.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import UIKit

final class BarChartColumnView: UIView {
    private let barColumn: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let columnTitle = TextLabel(
        font: .systemFont(
            ofSize: 11,
            weight: .regular
        ),
        textColor: Asset.petGray.color
    )
    
    private var barHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        addSubview(barColumn)
        addSubview(columnTitle)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        barColumn.translatesAutoresizingMaskIntoConstraints = false
        
        barHeightConstraint = barColumn.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            barColumn.leadingAnchor.constraint(equalTo: leadingAnchor),
            barColumn.trailingAnchor.constraint(equalTo: trailingAnchor),
            barColumn.bottomAnchor.constraint(equalTo: columnTitle.topAnchor, constant: -10),
            
            columnTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            columnTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            columnTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
            columnTitle.heightAnchor.constraint(equalToConstant: 16),

            topAnchor.constraint(lessThanOrEqualTo: barColumn.topAnchor)
        ])
        barHeightConstraint?.isActive = true
    }
    
    func configure(title: String, value: Double, maxValue: Double, color: UIColor) {
        columnTitle.text = title
        barColumn.backgroundColor = color
        
        let ratio: CGFloat
        if maxValue <= 0 {
            ratio = 0
        } else {
            ratio = CGFloat(value / maxValue)
        }
        
        let minHeight: CGFloat = ratio > 0 ? 8 : 0
        let maxHeight: CGFloat = 120
        let calculatedHeight = max(minHeight, maxHeight * ratio)
        
        barHeightConstraint?.constant = calculatedHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
