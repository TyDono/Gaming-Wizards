//
//  TimeUtils.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/8/23.
//

import Foundation

protocol TimeUtilsService {
    func timeAgoString(from date: Date) -> String
}

struct TimeUtils: TimeUtilsService {
    
    func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let components = calendar.dateComponents([.hour, .minute], from: date, to: now)
            if let hours = components.hour, hours > 0 {
                return "\(hours) hour\(hours == 1 ? "" : "s") ago"
            } else if let minutes = components.minute, minutes > 0 {
                return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
            } else {
                return "Just now"
            }
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let components = calendar.dateComponents([.day], from: date, to: now)
            if let days = components.day, days < 7 {
                return "\(days) day\(days == 1 ? "" : "s") ago"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy" // Customize date format as needed
                return dateFormatter.string(from: date)
            }
        }
    }
}
