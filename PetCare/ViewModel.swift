//
//  ViewModel.swift
//  PetCare
//
//  Created by Ляйсан on 25/3/26.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Intent

    var state: State { get }

    func trigger(_ intent: Intent)
}
