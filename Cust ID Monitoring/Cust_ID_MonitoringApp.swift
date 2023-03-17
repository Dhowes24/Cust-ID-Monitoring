//
//  Cust_ID_MonitoringApp.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import SwiftUI

@main
struct Cust_ID_MonitoringApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 450, idealWidth: 550, maxWidth: 600, minHeight: 750, idealHeight: 750, maxHeight: 750)
        }
        .windowResizability(.contentSize)
    }
}
