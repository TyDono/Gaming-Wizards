//
//  Order.swift
//  Foodiii
//
//  Created by Tyler Donohue on 10/6/22.
//

import Foundation

struct Order: Identifiable, Codable {
    var id: String?
    var maxCostLimit: Double?
    var restaurants: [String?] //the restaurants ordered from
    var foodItems: [String?]
}
