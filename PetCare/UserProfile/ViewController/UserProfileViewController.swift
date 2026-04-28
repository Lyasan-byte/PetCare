//
//  UserProfileViewController.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import UIKit
import Combine

final class UserProfileViewController: UIViewController {
    private let viewModel: any UserProfileViewModeling
    private let imageLoader: ImageLoader
    private let contentView = UserProfileView()
    private var bag = Set<AnyCancellable>()

    init(viewModel: any UserProfileViewModeling, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindLanguageChanges()
        setupActions()
        viewModel.trigger(.onDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        contentView.refreshLocalizedTexts()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func bind() {
        viewModel.stateDidChange
            .sink { [weak self] in
                self?.render()
            }
            .store(in: &bag)
    }

    private func bindLanguageChanges() {
        NotificationCenter.default.publisher(for: .settingsLanguageDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.refreshLocalizedTexts()
                self?.render()
            }
            .store(in: &bag)
    }

    private func setupActions() {
        contentView.addEditTarget(self, action: #selector(editTapped))
        contentView.settingsRow.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        contentView.logoutRow.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            contentView.setLoading(true)
        case .content(let content):
            contentView.setLoading(false)
            contentView.configure(content: content, imageLoader: imageLoader)
        case .error(let message):
            contentView.setLoading(false)
            showAlert(message: message)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("common.error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("common.ok", comment: ""), style: .default))
        present(alert, animated: true)
    }

    private func showLogoutConfirmationAlert() {
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(
            title: NSLocalizedString("user.profile.logout.confirmation.title", comment: ""),
            message: NSLocalizedString("user.profile.logout.confirmation.message", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("common.cancel", comment: ""),
                style: .cancel
            )
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("user.profile.logout.title", comment: ""),
                style: .destructive
            ) { [weak self] _ in
                self?.viewModel.trigger(.logoutTapped)
            }
        )
        present(alert, animated: true)
    }

    @objc private func editTapped() {
        viewModel.trigger(.editTapped)
    }

    @objc private func settingsTapped() {
        viewModel.trigger(.settingsTapped)
    }

    @objc private func logoutTapped() {
        showLogoutConfirmationAlert()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
