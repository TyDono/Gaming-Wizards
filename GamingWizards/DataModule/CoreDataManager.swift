//
//  CoreDataManager.swift
//  Foodiii
//
//  Created by Tyler Donohue on 2/27/23.
//

//import Foundation
//import CoreData
//
//class CoreDataManager: ObservableObject {
//    let persistentContainer: NSPersistentContainer
//    static let shared = CoreDataManager()
//    var viewContext: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    private init() {
//        persistentContainer = NSPersistentContainer(name: "FoodiiiContainer")
//        persistentContainer.loadPersistentStores { (description, err) in
//            if let error = err {
//                fatalError("UNABLE TO INITIALIZE CORE DATA STACK: \(error)")
//            }
//        }
//    }
//
//}
