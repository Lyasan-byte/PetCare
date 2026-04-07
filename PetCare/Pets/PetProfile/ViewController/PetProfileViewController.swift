//
//  PetProfileViewController.swift
//  PetCare
//
//  Created by Ляйсан on 30/3/26.
//

import UIKit
import Combine

final class PetProfileViewController: UIViewController {
    private let petProfileView = PetProfileView()
    private let petProfileViewModel: any PetProfileViewModeling
    private let imageLoader: ImageLoader
    private var bag = Set<AnyCancellable>()
    
    init(petProfileViewModel: any PetProfileViewModeling, imageLoader: ImageLoader) {
        self.petProfileViewModel = petProfileViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupHierarchy()
        setupLayout()
        bindViewModel()
        bindActions()
        render(petProfileViewModel.state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupHierarchy() {
        view.addSubview(petProfileView)
    }
    
    private func setupAppearance() {
        title = "Pet Profile"
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            petProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            petProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        petProfileViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.petProfileViewModel.state)
            }
            .store(in: &bag)
    }
    
    private func bindActions() {
        petProfileView.createActivityButton.onTap = { [weak self] in
            self?.petProfileViewModel.trigger(.onCreateActivityTap)
        }
        petProfileView.editButton.onTap = { [weak self] in
            self?.petProfileViewModel.trigger(.onEditTap)
        }
        
        petProfileView.analyticsButton.onTap = { [weak self] in
            self?.petProfileViewModel.trigger(.onAnalyticsTap)
        }
    }
    
    private func render(_ state: PetProfileState) {
        petProfileView.setPetData(state.pet, imageLoader: imageLoader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
