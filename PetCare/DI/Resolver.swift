//
//  Resolver.swift
//  PetCare
//
//  Created by Ляйсан on 28/4/26.
//

import Swinject
import Foundation

extension Resolver {
    func resolveOrFail<Service>(_ serviceType: Service.Type = Service.self) -> Service {
        guard let service = resolve(serviceType) else {
            fatalError("Dependency \(serviceType) is not registered in DI container")
        }
        return service
    }

    func resolveOrFail<Service, Arg1>(
        _ serviceType: Service.Type = Service.self,
        argument: Arg1
    ) -> Service {
        guard let service = resolve(serviceType, argument: argument) else {
            fatalError("Dependency \(serviceType) with argument \(Arg1.self) is not registered in DI container")
        }
        return service
    }

    func resolveOrFail<Service, Arg1, Arg2>(
        _ serviceType: Service.Type = Service.self,
        arguments arg1: Arg1, _ arg2: Arg2
    ) -> Service {
        guard let service = resolve(serviceType, arguments: arg1, arg2) else {
            fatalError(
                "Dependency \(serviceType) with arguments \(Arg1.self), \(Arg2.self) is not registered in DI container"
            )
        }
        return service
    }
}
