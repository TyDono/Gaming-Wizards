//
//  ReportReason.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/23.
//

import Foundation

enum ReportReason: String, Codable, CaseIterable {
    case spam = "spam"
    case fakeAccount = "fake account"
    case inappropriateName = "inappropriate name"
    case inappropriatePhoto = "inappropriate photo"
    case inappropriateAbout = "inappropriate about"
    case inappropriateTags = "inappropriate tags"
    case advertisement = "advertisement"
    case other = "other"
}
