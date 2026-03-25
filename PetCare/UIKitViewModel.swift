//
//  UIKitViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 25/3/26.
//

import Foundation

@MainActor
protocol UIKitViewModel: ViewModel {
    var stateDidChange: ObservableObjectPublisher { get }
}
