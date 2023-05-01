//
//  Invitation.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/6/22.
//

import Foundation

struct Invitation: Equatable, Codable {
    var id: String
    var inviterName: String
    var endTime: Date //make a formula to get when the date ends, then in the viewModel, it will calculate how much time is left, dispalying the actual end time with a count down that will appear and show how much time is left. make a notification if the user hasnt submited and order by the 10 min mark
    var orderOpen: Bool //if time is 0 then this is false and the user cannot change or alter the order
    var lastMinOrder: Bool //if true then the user can make orders that bypass orderOpen
    var maxCostLimit: Double? //how much can be order cost wise
    var availableRestaurants: [String]
    //POST MVP
//    var paymentIsTrue: Bool //is the user requires the order to make payment at all for the order to go through
    
}
