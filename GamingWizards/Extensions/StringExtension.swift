//
//  StringExtension.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/28/22.
//

import Foundation
import Foundation

extension String {
    
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssz"
            
            return dateFormatter
        }()
    }
    
    func toDateString(inputDateFormat inputFormat: String, outputDateFormat outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date!)
    }
    
    var dateFromUTC: Date? {
        return Formatter.utcFormatter.date(from: self)
    }
    
    var isValidPassword: Bool{
        let passRegEx = "[A-Z0-9a-z.!@#$%^&*]{6,30}"
        return NSPredicate(format: "SELF MATCHES %@", passRegEx).evaluate(with: self)
    }
    
    var isValidUserPass: Bool{
        let userPassRegEx = "[A-Za-z]{2,30}"
        return NSPredicate(format: "SELF MATCHES %@", userPassRegEx).evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
}
