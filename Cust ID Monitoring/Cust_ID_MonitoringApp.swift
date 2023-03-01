//
//  Cust_ID_MonitoringApp.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import SwiftUI

@main
struct Cust_ID_MonitoringApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .frame(minWidth: 250, idealWidth: 350, maxWidth: 500, minHeight: 500, idealHeight: 525, maxHeight: 550)
        }
        .windowResizability(.contentSize)
    }
}
