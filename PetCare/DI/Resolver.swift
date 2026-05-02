//
//  Resolver.swift
//  PetCare
//
//  Created by Ляйсан on 28/4/26.
//

import Swinject
import Foundation

extension Resolver {
    func resolve<T>() -> T {
        guard let result = resolve(T.self) else {
            fatalError("Could not resolve \(T.self)")
        }
        return result
    }

    func resolve<T, Argument>(argument: Argument) -> T {
        guard let result = resolve(T.self, argument: argument) else {
            fatalError("Could not resolve \(T.self) with argument \(argument)")
        }
        return result
    }
}
