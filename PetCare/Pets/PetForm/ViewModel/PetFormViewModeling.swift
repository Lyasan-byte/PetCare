//
//  PetFormViewModeling.swift
//  PetCare
//
//  Created by Ляйсан on 27/3/26.
//

import Combine

protocol PetFormViewModeling: UIKitViewModel where State == PetFormState, Intent == PetFormIntent {}
