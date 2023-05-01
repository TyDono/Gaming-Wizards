//
//  DataManager.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 1/23/23.
//

import Foundation
import CoreData
import SwiftUI

//lua of errors
//class DataManager: NSObject, ObservableObject {
//
//    static let shared = DataManager(type: .normal)
//    static let preview = DataManager(type: .preview)
//    static let testing = DataManager(type: .testing)
//
//    @Published var todos: OrderedDictionary<UUID, Todo> = [:]
//    @Published var projects: OrderedDictionary<UUID, Project> = [:]
//
//    var todosArray: [Todo] {
//        Array(todos.values)
//    }
//
//    var projectsArray: [Project] {
//        Array(projects.values)
//    }
//
//    fileprivate var managedObjectContext: NSManagedObjectContext
//    private let todosFRC: NSFetchedResultsController<TodoMO>
//    private let projectsFRC: NSFetchedResultsController<ProjectMO>
//
//    private init(type: DataManagerType) {
//        switch type {
//        case .normal:
//            let persistentStore = PersistentStore()
//            self.managedObjectContext = persistentStore.context
//        case .preview:
//            let persistentStore = PersistentStore(inMemory: true)
//            self.managedObjectContext = persistentStore.context
//            // Add Mock Data
//            try? self.managedObjectContext.save()
//        case .testing:
//            let persistentStore = PersistentStore(inMemory: true)
//            self.managedObjectContext = persistentStore.context
//        }
//
//        let todoFR: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()
//        todoFR.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//        todosFRC = NSFetchedResultsController(fetchRequest: todoFR,
//                                              managedObjectContext: managedObjectContext,
//                                              sectionNameKeyPath: nil,
//                                              cacheName: nil)
//
//        let projectFR: NSFetchRequest<ProjectMO> = ProjectMO.fetchRequest()
//        projectFR.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        projectsFRC = NSFetchedResultsController(fetchRequest: projectFR,
//                                                 managedObjectContext: managedObjectContext,
//                                                 sectionNameKeyPath: nil,
//                                                 cacheName: nil)
//
//        super.init()
//
//        // Initial fetch to populate todos array
//        todosFRC.delegate = self
//        try? todosFRC.performFetch()
//        if let newTodos = todosFRC.fetchedObjects {
//            self.todos = OrderedDictionary(uniqueKeysWithValues: newTodos.map({ ($0.id!, Todo(todoMO: $0)) }))
//        }
//
//        projectsFRC.delegate = self
//        try? projectsFRC.performFetch()
//        if let newProjects = projectsFRC.fetchedObjects {
//            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
//        }
//    }
//
//    func saveData() {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch let error as NSError {
//                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
//            }
//        }
//    }
//}
//
//extension DataManager: NSFetchedResultsControllerDelegate {
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        if let newTodos = controller.fetchedObjects as? [TodoMO] {
//            self.todos = OrderedDictionary(uniqueKeysWithValues: newTodos.map({ ($0.id!, Todo(todoMO: $0)) }))
//        } else if let newProjects = controller.fetchedObjects as? [ProjectMO] {
//            print(newProjects)
//            self.projects = OrderedDictionary(uniqueKeysWithValues: newProjects.map({ ($0.id!, Project(projectMO: $0)) }))
//        }
//    }
//}
