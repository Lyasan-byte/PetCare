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
    private var bag = Set<AnyCancellable>()
    
    var onRoute: ((PetProfileRoute) -> Void)?
    
    init(petProfileViewModel: any PetProfileViewModeling) {
        self.petProfileViewModel = petProfileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupHierarchy()
        setupLayout()
        render(petProfileViewModel.state)
    }
    
    private func setupHierarchy() {
        view.addSubview(petProfileView)
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
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.petProfileViewModel.state)
            }
            .store(in: &bag)
        petProfileViewModel.routePublisher
            .sink { [weak self] route in
                self?.handle(route)
            }
            .store(in: &bag)
    }
    
    private func render(_ state: PetProfileState) {
        petProfileView.setPetData(state.pet)
    }
    
    private func handle(_ route: PetProfileRoute) {
        switch route {
        case .showEdit(let pet):
            onRoute?(.showEdit(pet))
        case .showAnalytics(let pet):
            onRoute?(.showAnalytics(pet))
        case .close:
            onRoute?(.close)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
