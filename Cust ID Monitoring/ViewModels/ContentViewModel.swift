//
//  ContentViewModel.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import Foundation
import SwiftUI

extension String {
    func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return components(separatedBy: characterSet).joined()
    }
}

@MainActor class ContentViewModel: ObservableObject {
        
        @Published var custIDs: String = ""
        @Published var document: CSVDocument = CSVDocument(message: "")
        @Published var isImporting: Bool = false
        @Published var fileImported: Bool = false
        @Published var isExporting: Bool = false
        @Published var progress: Double = -0.1
        @Published var showError: Bool = false
        
        func parseDoc() async {
            var newFile: String = ""
            let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
            var rows = document.message.components(separatedBy: "\n")
            newFile.append("\(rows.removeFirst())\n")
            self.progress = 0
            
            for row in rows {
                withAnimation{
                    self.progress += (1/Double(rows.count))
                }
                let columns = row.components(separatedBy: ",")
                if custIDs.contains(columns[0]) {
                    newFile.append("\(row)\n")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.progress = 1.1
            }
            document.message = newFile
        }
    }

