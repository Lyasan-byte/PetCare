//
//  MiniGameViewModeling.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 09/04/26.
//

import Combine

protocol MiniGameViewModeling: UIKitViewModel where State == MiniGameState, Intent == MiniGameIntent {}
