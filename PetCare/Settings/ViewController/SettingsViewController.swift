//
//  SettingsViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import UIKit
import Combine

final class SettingsViewController: UIViewController {
    private let viewModel: any SettingsViewModeling
    private let contentView = SettingsView()
    private var bag = Set<AnyCancellable>()

    init(viewModel: any SettingsViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("settings.screen.title", comment: "")
        navigationItem.largeTitleDisplayMode = .never
        bindViewModel()
        bindActions()
        render(state: viewModel.state)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = Asset.accentColor.color
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Asset.accentColor.color
        ]
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            viewModel.trigger(.backTapped)
        }
    }

    private func bindViewModel() {
        viewModel.stateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.render(state: self.viewModel.state)
            }
            .store(in: &bag)
    }

    private func bindActions() {
        contentView.onAllNotificationsToggle = { [weak self] isEnabled in
            self?.viewModel.trigger(.allNotificationsToggled(isEnabled))
        }
        contentView.onGroomingToggle = { [weak self] isEnabled in
            self?.viewModel.trigger(.groomingToggled(isEnabled))
        }
        contentView.onVeterinarianToggle = { [weak self] isEnabled in
            self?.viewModel.trigger(.veterinarianToggled(isEnabled))
        }
        contentView.onGeneralRemindersToggle = { [weak self] isEnabled in
            self?.viewModel.trigger(.generalRemindersToggled(isEnabled))
        }
    }

    private func render(state: SettingsState) {
        contentView.render(state: state)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
