//
//  ViewState.swift
//  PetCare
//
//  Created by Artur Bagautdinov on 26.03.2026.
//

import Foundation

enum ViewState<Content> {
    case loading
    case content(Content)
    case error(String)
}
