//
//  RegisterViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 01.04.2026.
//

import Foundation

protocol RegisterViewModeling: UIKitViewModel where State == RegisterState, Intent == RegisterIntent {}
