//
//  PetsMainViewModeling.swift
//  PetCare
//
//  Created by Ляйсан on 28/3/26.
//

import Combine

protocol PetsMainViewModeling: UIKitViewModel where State == PetsMainState, Intent == PetsMainIntent {
    var routePublisher: AnyPublisher<PetsMainRoute, Never> { get }
}
