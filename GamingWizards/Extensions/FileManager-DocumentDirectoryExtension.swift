//
//  FileManager-DocumentDirectoryExtension.swift
//  Foodiii
//
//  Created by Tyler Donohue on 10/24/22.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
