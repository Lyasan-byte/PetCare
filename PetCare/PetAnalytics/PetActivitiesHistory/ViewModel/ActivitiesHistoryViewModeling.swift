//
//  ActivitiesHistoryViewModeling.swift
//  PetCare
//
//  Created by Ляйсан on 13/4/26.
//

import Foundation

protocol ActivitiesHistoryViewModeling: UIKitViewModel where State == ActivitiesHistoryState,
                                                             Intent == ActivitiesHistoryIntent {}
