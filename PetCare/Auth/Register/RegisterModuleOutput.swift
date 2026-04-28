//
//  RegisterModuleOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import UIKit

protocol RegisterModuleOutput: AnyObject {
    func tapLogin()
    func moduleWantsToOpenOnboardingHelp()
    func moduleWantsToOpenMainScreen()
    func moduleWantsToOpenRegistrationCompletion()
    func provideViewControllerForGoogleSignIn() -> UIViewController?
}
