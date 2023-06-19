//
//  TextExtension.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/22/23.
//

//import Foundation
import SwiftUI

extension Text {
    
    func boldIfStringIsMatching(_ string1: String, _ string2: String) -> Text {
        if string1 == string2 {
            return self.bold()
        } else {
            return self
        }
    }
    
}
