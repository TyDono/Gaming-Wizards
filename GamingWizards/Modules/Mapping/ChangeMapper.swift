//
//  ChangeMapper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/2/23.
//

import Foundation

struct ChangeMapper {
    
    static func mapChanges<T: Updatable, U: Updatable>(from oldData: T, to newData: U) -> [String: Any] {
        return newData.updatedFields(from: oldData)
    }
    
}
