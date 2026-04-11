//
//  PetAnalyticsChartCell.swift
//  PetCare
//
//  Created by Ляйсан on 10/4/26.
//

import UIKit

final class PetAnalyticsChartCell: UICollectionViewCell {
    static let identifier = "PetAnalyticsChartCell"
    
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let chartTitle = TextLabel(
        font: .systemFont(
            ofSize: 18,
            weight: .semibold
        ),
        textAlignment: .left
    )
    private let chartSubtitle = TextLabel(
        font: .systemFont(
            ofSize: 14,
            weight: .regular
        ),
        textColor: Asset.petGray.color,
        textAlignment: .left
    )
    
    private let barChart = BarChartView()
    private lazy var textStack = VStack(arrangedSubviews: [chartTitle, chartSubtitle])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupHierarchy() {
        contentView.addSubview(background)
        background.addSubview(textStack)
        background.addSubview(barChart)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            
            barChart.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 16),
            barChart.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            barChart.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            barChart.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(items: [BarChartItem], color: UIColor, chartTitle: String, subtitle: String) {
        barChart.configure(items: items, color: color)
        self.chartTitle.text = chartTitle
        self.chartSubtitle.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
