//
//  PetsMainViewController.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import UIKit
import Combine

final class PetsMainViewController: UIViewController {
    private let petsMainView = PetsMainView()
    private let petsMainViewModel: any PetsMainViewModeling
    private var bag = Set<AnyCancellable>()
    
    var onRoute: ((PetsMainRoute) -> ())?
    
    init(petsMainviewModel: PetsMainViewModel) {
        self.petsMainViewModel = petsMainviewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupHierarchy()
        setupLayout()
        setupPetsTableView()
        
        bindAction()
        bindViewModel()
        render(petsMainViewModel.state)
        
        petsMainViewModel.trigger(.viewDidLoad)
    }
    
    private func setupHierarchy() {
        view.addSubview(petsMainView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            petsMainView.topAnchor.constraint(equalTo: view.topAnchor),
            petsMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petsMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petsMainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPetsTableView() {
        petsMainView.petsTableView.register(PetCardCell.self, forCellReuseIdentifier: PetCardCell.identifier)
        petsMainView.petsTableView.dataSource = self
        petsMainView.petsTableView.delegate = self
    }
    
    private func render(_ state: PetsMainState) {
        petsMainView.tip.setText(text: state.tipText)
        
        petsMainView.petsTableView.reloadData()
        
        petsMainView.showEmptyStateView(state.isEmptyState)
        
        petsMainView.setLoading(state.isLoading)
    }
    
    private func handle(_ route: PetsMainRoute) {
        switch route {
        case .showQuickAction(_):
            break
        case .showPet(let pet):
            onRoute?(.showPet(pet))
        case .showAddPet:
            onRoute?(.showAddPet)
        case .showError(let string):
            showError(string)
        }
    }
    
    private func bindAction() {
        petsMainView.tip.onTipTap = { [weak self] in
            self?.petsMainViewModel.trigger(.onTipTap)
        }
        
        petsMainView.onAddPetButtonTap = { [weak self] in
            self?.petsMainViewModel.trigger(.onAddPetTap)
        }
    }
    
    private func bindViewModel() {
        petsMainViewModel.stateDidChange
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.petsMainViewModel.state)
            }
            .store(in: &bag)
        
        petsMainViewModel.routePublisher
            .sink { [weak self] route in
                self?.handle(route)
            }
            .store(in: &bag)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
        present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetsMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petsMainViewModel.state.pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PetCardCell.identifier, for: indexPath) as? PetCardCell {
            cell.setData(pet: petsMainViewModel.state.pets[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension PetsMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        petsMainViewModel.trigger(.onPetTap(petsMainViewModel.state.pets[indexPath.row]))
    }
}
