//
//  LoginModuleOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import UIKit

protocol LoginModuleOutput: AnyObject {
    func tapRegister()
    func moduleWantsToOpenMainScreen()
    func provideViewControllerForGoogleSignIn() -> UIViewController?
}
