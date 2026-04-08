//
//  RegistrationCompletionViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 06.04.2026.
//

import Foundation

protocol RegistrationCompletionViewModeling: UIKitViewModel
where State == RegistrationCompletionState, Intent == RegistrationCompletionIntent {}
