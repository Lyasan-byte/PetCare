//
//  SettingsCoordinator.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import UIKit

final class SettingsCoordinator: Coordinator {
    private let navigationController: UINavigationController

    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = SettingsViewModel(moduleOutput: self)
        let viewController = SettingsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SettingsCoordinator: SettingsModuleOutput {
    func settingsModuleDidClose() {
        onFinish?()
    }
}
