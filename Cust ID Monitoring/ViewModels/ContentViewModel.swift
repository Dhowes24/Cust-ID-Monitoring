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

enum docType {
    case health,ingestion,live
}

@MainActor class ContentViewModel: ObservableObject {
    
    @Published var custIDs: String = ""
    
    @Published var healthDoc: CSVDocument = CSVDocument(message: "")
    @Published var healthImporting: Bool = false
    @Published var healthImported: Bool = false
    @Published var healthWrongFile: Bool = false
    
    
    @Published var ingestionDoc: CSVDocument = CSVDocument(message: "")
    @Published var ingestionImporting: Bool = false
    @Published var ingestionImported: Bool = false
    @Published var ingestionWrongFile: Bool = false
    
    
    @Published var liveDoc: CSVDocument = CSVDocument(message: "")
    @Published var liveImporting: Bool = false
    @Published var liveImported: Bool = false
    @Published var liveWrongFile: Bool = false
    
    
    @Published var exportDoc: CSVDocument = CSVDocument(message: "")
    @Published var isExporting: Bool = false
    @Published var readyForExport: Bool = false
    
    @Published var progress: Double = -0.1
    var totalRows: Int = 0
    @Published var showError: Bool = false
    
    var data = [String: String]()
    
    func confirmHealth() {
        if healthDoc.message != "" {
            let rows = healthDoc.message.components(separatedBy: "\n")
            let columns = rows[0].components(separatedBy: ",")
            healthWrongFile = !(columns[2] == "order_uuid")
        }
    }
    
    func confirmIngestion() {
        if ingestionDoc.message != "" {
            let rows = ingestionDoc.message.components(separatedBy: "\n")
            let columns = rows[0].components(separatedBy: ",")
            ingestionWrongFile = !(columns[2] == "start_time")
        }
    }
    
    func confirmLive() {
        if liveDoc.message != "" {
            let rows = liveDoc.message.components(separatedBy: "\n")
            let columns = rows[0].components(separatedBy: ",")
            liveWrongFile =  !(columns[2] == "financial_status")
        }
    }
    
    func ConfirmFile() {
        confirmHealth()
        confirmIngestion()
        confirmLive()
    }
    
    func parseHealth(){
        if healthImported && !healthWrongFile {
            let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
            var rows = healthDoc.message.components(separatedBy: "\n")
            var containsID = false
            let header = "\(rows.removeFirst())\n"
            for row in rows {
                withAnimation{
                    self.progress += (1/Double(rows.count))
                }
                let columns = row.components(separatedBy: ",")
                if custIDs.contains(columns[0]) {
                    containsID = true
                    if data[columns[0]] == nil {
                        data[columns[0]] = "\(row)\n"
                    } else {
                        let currentValue = data[columns[0]]
                        data[columns[0]] = "\(currentValue ?? "")\(row)\n"
                    }
                }
            }
            if containsID {
                exportDoc.message.append(header)
            }
        }
    }
    
    func parseIngestion() {
        if ingestionImported && !ingestionWrongFile {
            let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
            var rows = ingestionDoc.message.components(separatedBy: "\n")
            let header = "\(rows.removeFirst())\n"
            
            for row in rows {
                withAnimation{
                    self.progress += (1/Double(rows.count))
                }
                let columns = row.components(separatedBy: ",")
                if custIDs.contains(columns[0]) {
                    if data[columns[0]] == nil {
                        data[columns[0]] = "Latest Ingestion,\(header)\(row)\n"
                    } else {
                        let currentValue = data[columns[0]]
                        data[columns[0]] = "\n\(currentValue ?? "")Latest Ingestion,\(header),\(row)\n"
                    }
                }
            }
        }
    }
    
    func parseLive() {
        if liveImported && !liveWrongFile {
            let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
            var rows = liveDoc.message.components(separatedBy: "\n")
            let header = "\(rows.removeFirst())\n"
            
            for row in rows {
                withAnimation{
                    self.progress += (1/Double(rows.count))
                }
                let columns = row.components(separatedBy: ",")
                if custIDs.contains(columns[0]) {
                    if data[columns[0]] == nil {
                        data[columns[0]] = "Integration Live,\(header)\(row)\n"
                    } else {
                        let currentValue = data[columns[0]]
                        data[columns[0]] = "\n\(currentValue ?? "")Integration Live,\(header),\(row)\n"
                    }
                }
            }
        }
    }
    
    func parseDoc() async {
        data.removeAll()
        exportDoc.message = ""
        
        parseHealth()
        parseIngestion()
        parseLive()
        
        for row in data.values {
            exportDoc.message.append("\(row)")
        }
        
        if exportDoc.message == "" {
            exportDoc.message.append("No Instances of any given IDs in any give files")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.readyForExport = true
            self.progress = 1.1
        }
    }
    
    func readyToParse() -> Bool {
        return (ingestionImported || healthImported || liveImported) && custIDs != ""
    }
}

