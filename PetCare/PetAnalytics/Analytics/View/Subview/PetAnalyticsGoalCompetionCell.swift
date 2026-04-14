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
            ofSize: 18,
            weight: .semibold
        ),
        text: L10n.PetAnalytics.GoalCompletion.title,
        textAlignment: .left
    )
    private let progressRing = ProgressRingView(
        subtitle: L10n.PetAnalytics.GoalCompletion.ProgressRing.subtitle
    )
    private let goalDescription = TextLabel(
        font: .systemFont(
            ofSize: 13,
            weight: .medium
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
        background.addSubview(progressRing)
        background.addSubview(goalDescription)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            goalTitle.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            goalTitle.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            goalTitle.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            
            progressRing.topAnchor.constraint(equalTo: goalTitle.bottomAnchor, constant: 16),
            progressRing.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            progressRing.heightAnchor.constraint(equalToConstant: 140),
            progressRing.widthAnchor.constraint(equalToConstant: 140),
            
            goalDescription.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 16),
            goalDescription.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            goalDescription.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            goalDescription.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(goalCompletion: GoalCompletionData) {
        goalDescription.text = goalCompletion.description
        progressRing
            .configure(
                goal: goalCompletion.goalsCount,
                actualValue: goalCompletion.actualGoalsCompletion,
                progress: goalCompletion.progress
            )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
