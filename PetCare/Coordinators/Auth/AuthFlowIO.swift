//
//  AuthFlowIO.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 29.03.2026.
//

import Foundation

protocol AuthFlowInput: AnyObject {}
protocol AuthFlowOutput: AnyObject {
    func authFlowWantsToOpenMainScreen()
}
