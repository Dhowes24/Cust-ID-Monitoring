//
//  DataController.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/1/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CustId")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Core data failed to load \(error.localizedDescription)")
            }
        }
    }
}
