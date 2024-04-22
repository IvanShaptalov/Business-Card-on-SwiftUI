//
//  BusinessCardGeneratorApp.swift
//  BusinessCardGenerator
//
//  Created by PowerMac on 22.04.2024.
//

import SwiftUI

@main
struct BusinessCardGeneratorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
