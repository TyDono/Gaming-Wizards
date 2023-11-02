//
//  FirestoreError.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/2/23.
//

import Foundation

enum FirestoreError: Error {
    case updateFailed(String)
    case documentNotFound
}
