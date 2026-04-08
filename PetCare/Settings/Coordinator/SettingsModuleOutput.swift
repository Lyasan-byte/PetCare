//
//  SettingsModuleOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation
import UIKit

protocol SettingsModuleOutput: AnyObject {
    func settingsModuleDidClose()
    func provideViewControllerForAccountDeletion() -> UIViewController?
}
