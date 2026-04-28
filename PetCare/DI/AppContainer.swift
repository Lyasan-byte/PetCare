//
//  AppContainer.swift
//  PetCare
//
//  Created by Ляйсан on 28/4/26.
//

import Swinject
import Foundation

final class AppContainer {
    let assembler: Assembler
    
    var resolver: Resolver {
        assembler.resolver
    }
    
    init() {
        assembler = Assembler([
            CoreAssembly(),
            RepositoryAssembly(),
            CoordinatorAssembly()
        ])
    }
}
