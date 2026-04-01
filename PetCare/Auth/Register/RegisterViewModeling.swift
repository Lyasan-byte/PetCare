//
//  RegisterViewModeling.swift
//  PetCare
//
//  Created by Codex on 01.04.2026.
//

import Foundation

protocol RegisterViewModeling: UIKitViewModel where State == RegisterState, Intent == RegisterIntent {}
