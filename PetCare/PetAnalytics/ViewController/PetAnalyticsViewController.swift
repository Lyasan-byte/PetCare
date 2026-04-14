//
//  PetAnalyticsViewController.swift
//  PetCare
//
//  Created by Ляйсан on 9/4/26.
//

import Combine
import UIKit

final class PetAnalyticsViewController: UIViewController {
    private let petAnalyticsView = PetAnalyticsView()
    private let petAnalyticsViewModel: any PetAnalyticsViewModeling
    
    private var bag = Set<AnyCancellable>()
    
    init(petAnalyticsViewModel: any PetAnalyticsViewModeling) {
        self.petAnalyticsViewModel = petAnalyticsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupHierarchy()
        setupLayout()
        setupCollection()
        bindViewModel()
    }
    
    private func setupAppearance() {
        title = "Analytics"
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupHierarchy() {
        view.addSubview(petAnalyticsView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petAnalyticsView.topAnchor.constraint(equalTo: view.topAnchor),
            petAnalyticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petAnalyticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petAnalyticsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollection() {
        petAnalyticsView.registerCells()
    }
    
    private func bindViewModel() {
        petAnalyticsViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.render()
            }
            .store(in: &bag)
    }
    
    private func render() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
