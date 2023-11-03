//
//  Updatable.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/2/23.
//

import Foundation

protocol Updatable {
//    func updatedFields<T: Updatable>(from other: T) -> [String: Any]
    func updatedFields<U: Updatable>(from other: U) -> [String: Any]
}
