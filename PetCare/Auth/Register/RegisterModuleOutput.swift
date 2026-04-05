//
//  RegisterModuleOutput.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import UIKit

protocol RegisterModuleOutput: AnyObject {
    func tapLogin()
    func moduleWantsToOpenMainScreen()
    func provideViewControllerForGoogleSignIn() -> UIViewController?
}
