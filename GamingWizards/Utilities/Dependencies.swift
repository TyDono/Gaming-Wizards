//
//  Dependencies.swift
//  Foodiii
//
//  Created by Tyler Donohue on 4/5/23.
//

import Foundation

struct Dependencies {
    init() { //provider dependencies here
        @Provider var foodThemeSelectionViewModel = FoodThemeSelectionViewModel()
    }
    
}
let dependencies = Dependencies()
