//
//  PetProfileViewModeling.swift
//  PetCare
//
//  Created by Ляйсан on 31/3/26.
//

import Foundation
import Combine

protocol PetProfileViewModeling: UIKitViewModel where State == PetProfileState, Intent == PetProfileIntent {
    var routePublisher: AnyPublisher<PetProfileRoute, Never> { get }
}
