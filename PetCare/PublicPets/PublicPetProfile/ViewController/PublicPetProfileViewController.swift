//
//  PublicPetProfileViewController.swift
//  PetCare
//
//  Created by Ляйсан on 3/4/26.
//

import UIKit
import Combine

final class PublicPetProfileViewController: UIViewController {
    private let publicPetProfileView = PublicPetProfileView()
    private let publicPetProfileViewModel: any PublicPetProfileViewModeling
    private let imageLoader: ImageLoader
    private var bag = Set<AnyCancellable>()

    init(publicPetProfileViewModel: any PublicPetProfileViewModeling, imageLoader: ImageLoader) {
        self.publicPetProfileViewModel = publicPetProfileViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupHierarchy()
        setupLayout()
        bindViewModel()

        render(publicPetProfileViewModel.state)
        publicPetProfileViewModel.trigger(.onDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupHierarchy() {
        view.addSubview(publicPetProfileView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            publicPetProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            publicPetProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            publicPetProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            publicPetProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        publicPetProfileViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.publicPetProfileViewModel.state)
            }
            .store(in: &bag)
    }

    private func render(_ state: PublicPetProfileState) {
        switch state {
        case .loading:
            publicPetProfileView.setLoading(true)
        case .content(let content):
            publicPetProfileView.setLoading(false)
            publicPetProfileView.setData(pet: content.pet, user: content.user, imageLoader: imageLoader)
        case .error(let error):
            publicPetProfileView.setLoading(false)
            showError(error)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default) { [weak self] _ in
            self?.publicPetProfileViewModel.trigger(.onDismissAlert)
        })
        present(alert, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
