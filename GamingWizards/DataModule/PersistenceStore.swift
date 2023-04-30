////
////  PersistenceStore.swift
////  Foodiii
////
////  Created by Tyler Donohue on 1/23/23.
////
//
//import Foundation
//import CoreData
//import SwiftUI
//
//struct PersistentStore {
//    
//    let container: NSPersistentContainer
//    
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "FoodiiiContainer")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//    }
//    
//    var context: NSManagedObjectContext { container.viewContext }
//    
//    func saveContext () {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch let error as NSError {
//                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
//            }
//        }
//    }
//}
