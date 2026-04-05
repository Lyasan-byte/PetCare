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
        navigationController?.navigationBar.tintColor = nil
        navigationController?.navigationBar.titleTextAttributes = nil
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
        contentView.onThemeSelected = { [weak self] theme in
            self?.viewModel.trigger(.themeSelected(theme))
        }
        contentView.onLanguageSelected = { [weak self] language in
            self?.viewModel.trigger(.languageSelected(language))
        }
        contentView.onDeleteAccountTap = { [weak self] in
            self?.viewModel.trigger(.deleteAccountTapped)
        }
    }

    private func render(state: SettingsState) {
        title = NSLocalizedString("settings.screen.title", comment: "")
        contentView.render(state: state)
        renderDeleteConfirmationIfNeeded(state.isDeleteConfirmationPresented)
        renderErrorIfNeeded(state.errorMessage)
    }

    private func renderDeleteConfirmationIfNeeded(_ isPresented: Bool) {
        guard isPresented else { return }
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(
            title: NSLocalizedString("settings.account.delete.confirmation.title", comment: ""),
            message: NSLocalizedString("settings.account.delete.confirmation.message", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("common.cancel", comment: ""),
                style: .cancel
            ) { [weak self] _ in
                self?.viewModel.trigger(.dismissAlert)
            }
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("common.delete", comment: ""),
                style: .destructive
            ) { [weak self] _ in
                self?.viewModel.trigger(.confirmDeleteAccount)
            }
        )
        present(alert, animated: true)
    }

    private func renderErrorIfNeeded(_ message: String?) {
        guard let message else { return }
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(
            title: NSLocalizedString("common.error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("common.ok", comment: ""),
                style: .default
            ) { [weak self] _ in
                self?.viewModel.trigger(.dismissAlert)
            }
        )
        present(alert, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
