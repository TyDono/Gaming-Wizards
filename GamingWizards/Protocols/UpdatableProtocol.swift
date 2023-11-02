//
//  UpdatableProtocol.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/2/23.
//

import Foundation
import Firebase

protocol Updatable {
    func updatedFields<T: Updatable>(from other: T) -> [String: Any]
}
