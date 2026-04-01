//
//  LoginViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import Foundation

protocol LoginViewModeling: UIKitViewModel where State == LoginState, Intent == LoginIntent {}
