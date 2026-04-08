//
//  UserProfileViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 03.04.2026.
//

import Foundation

protocol UserProfileViewModeling: UIKitViewModel where State == UserProfileState, Intent == UserProfileIntent {}
