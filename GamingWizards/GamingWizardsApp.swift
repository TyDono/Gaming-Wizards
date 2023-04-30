//
//  GamingWizardsApp.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 4/29/23.
//

import SwiftUI

@main
struct GamingWizardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
