//
//  LoginViewModeling.swift
//  PetCare
//
//  Created by Codex on 01.04.2026.
//

import Foundation

protocol LoginViewModeling: UIKitViewModel where State == LoginState, Intent == LoginIntent {}
