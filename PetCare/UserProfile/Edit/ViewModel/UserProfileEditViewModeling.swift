//
//  UserProfileEditViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 05.04.2026.
//

import Foundation

protocol UserProfileEditViewModeling: UIKitViewModel
where State == UserProfileEditState, Intent == UserProfileEditIntent {}
