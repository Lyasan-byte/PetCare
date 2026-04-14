//
//  PetAnalyticsGoalCompetionCell.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import UIKit

final class PetAnalyticsGoalCompetionCell: UICollectionViewCell {
    static let identifier = "PetAnalyticsGoalCompetionCell"
        
    private let background = BackgroundView(backgroundColor: .tertiarySystemBackground)
    private let goalTitle = TextLabel(
        font: .systemFont(
            ofSize: 16,
            weight: .semibold
        ),
        text: "Goal Completion",
        textAlignment: .left
    )
    private let progressRing = ProgressRingView(subtitle: "GOALS")
    private let goalDescription = TextLabel(
        font: .systemFont(
            ofSize: 14,
            weight: .semibold
        ),
        textColor: Asset.petGray.color
    )
    
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
        background.addSubview(goalTitle)
        background.addSubview(goalDescription)
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            goalTitle.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            goalTitle.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            goalTitle.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            
            progressRing.topAnchor.constraint(equalTo: goalTitle.bottomAnchor, constant: 16),
            progressRing.heightAnchor.constraint(equalToConstant: 140),
            progressRing.widthAnchor.constraint(equalToConstant: 140),
            
            goalDescription.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 16),
            goalDescription.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            goalDescription.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            goalDescription.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(petName: String) {
        goalDescription.text = "\(petName.capitalized) is 60% through his fitness targets."
        // add data
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
