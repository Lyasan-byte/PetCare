//
//  PetActivityCreationViewController.swift
//  PetCare
//
//  Created by Ляйсан on 6/4/26.
//

import UIKit
import Combine

final class PetActivityCreationViewController: UIViewController {
    private let petActivityCreationView = PetActivityCreationView()
    private let imageLoader: ImageLoader
    private let petActivityCreationViewModel: any PetActivityCreationViewModeling
    
    private var bag = Set<AnyCancellable>()
    private var content: PetActivityCreationContent? {
        guard case .content(let content) = petActivityCreationViewModel.state else {
            return nil
        }
        return content
    }

    init(imageLoader: ImageLoader, petActivityCreationViewModel: any PetActivityCreationViewModeling) {
        self.imageLoader = imageLoader
        self.petActivityCreationViewModel = petActivityCreationViewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
        setupCollection()
        bindViewModel()
        bindActions()
        render(petActivityCreationViewModel.state)
        petActivityCreationViewModel.trigger(.onDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupAppearance() {
        title = "Create Activity"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(petActivityCreationView)
    }

    private func setupCollection() {
        petActivityCreationView.setupCollection(
            dataSource: self,
            delegate: self
        )
    }

    private func bindViewModel() {
        petActivityCreationViewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(self.petActivityCreationViewModel.state)
            }
            .store(in: &bag)
    }

    private func bindActions() {
        petActivityCreationView.activityPicker.onValueChanged = { [weak self] activity in
            let activity = PetActivityType.allCases[activity]
            self?.petActivityCreationViewModel.trigger(.onChangeActivity(activity))
        }

        petActivityCreationView.datePicker.onDateChange = { [weak self] date in
            self?.petActivityCreationViewModel.trigger(.onChangeDate(date))
        }

        petActivityCreationView.noteTextField.onNoteChange = { [weak self] note in
            self?.petActivityCreationViewModel.trigger(.onChangeNote(note))
        }

        petActivityCreationView.notificationsSwitch.onSwitchChange = { [weak self] isOn in
            self?.petActivityCreationViewModel.trigger(.onSwitchingNotifications(isOn))
        }

        petActivityCreationView.onWalkGoalChange = { [weak self] goalString in
            self?.petActivityCreationViewModel.trigger(.onChangeWalkGoal(goalString))
        }

        petActivityCreationView.onWalkActualChange = { [weak self] actualString in
            self?.petActivityCreationViewModel.trigger(.onChangeWalkActual(actualString))
        }

        petActivityCreationView.onGroomingProcedureChange = { [weak self] index in
            guard GroomingProcedureType.allCases.indices.contains(index) else { return }

            let procedureType = GroomingProcedureType.allCases[index]
            self?.petActivityCreationViewModel.trigger(.onChangeGroomingProcedureType(procedureType))
        }

        petActivityCreationView.onGroomingCostChange = { [weak self] costString in
            self?.petActivityCreationViewModel.trigger(.onChangeGroomingCost(costString))
        }

        petActivityCreationView.onVetProcedureChange = { [weak self] index in
            guard VetProcedureType.allCases.indices.contains(index) else { return }

            let procedureType = VetProcedureType.allCases[index]
            self?.petActivityCreationViewModel.trigger(.onChangeVetProcedureType(procedureType))
        }

        petActivityCreationView.onVetCostChange = { [weak self] costString in
            self?.petActivityCreationViewModel.trigger(.onChangeVetCost(costString))
        }

        petActivityCreationView.saveButton.onTap = { [weak self] in
            self?.petActivityCreationViewModel.trigger(.onSave)
        }
    }

    private func render(_ state: PetActivityCreationState) {
        switch state {
        case .loading:
            petActivityCreationView.setLoading(true)
        case .error(let error):
            petActivityCreationView.setLoading(false)
            showError(error)
        case .content(let content):
            petActivityCreationView.setLoading(false)
            petActivityCreationView.setData(
                selectedPet: content.selectedPet,
                selectedActivity: content.activity
            )
            petActivityCreationView.reloadData()
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default) { [weak self] _ in
            self?.petActivityCreationViewModel.trigger(.onDismissAlert)
        })
        present(alert, animated: true)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            petActivityCreationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            petActivityCreationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            petActivityCreationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            petActivityCreationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetActivityCreationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        PetActivityCreationSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = PetActivityCreationSection(rawValue: section) else { return 0 }

        switch section {
        case .petPhotoSelection:
            return content?.pets.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = PetActivityCreationSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .petPhotoSelection:
            if let content, let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetSelectionCollectionViewCell.identifier,
                for: indexPath
            ) as? PetSelectionCollectionViewCell {
                let pet = content.pets[indexPath.row]
                let isSelected = content.selectedPet == pet
                cell.setData(pet: pet, isSelected: isSelected, imageLoader: imageLoader)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension PetActivityCreationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = PetActivityCreationSection(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .petPhotoSelection:
            guard let content else { return }
            let pet = content.pets[indexPath.row]
            petActivityCreationViewModel.trigger(.onChangePet(pet))
        }
    }
}
