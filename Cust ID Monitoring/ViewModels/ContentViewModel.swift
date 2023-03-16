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
    var data = [String: String]()
    @Published var progress: Double = -0.1
    @Published var showError: Bool = false
    var totalRows: Int = 0
    
    @Published var healthReport: report = report()
    @Published var ingestionReport: report = report()
    @Published var liveReport: report = report()
    @Published var exportReport: report = report()
    
    func validateReports() {
        confirmReport(report: &healthReport, confirmationString: "order_number")
        confirmReport(report: &ingestionReport, confirmationString: "request_id")
        confirmReport(report: &liveReport, confirmationString: "merchant_status")
    }
    
    func confirmReport(report: inout report, confirmationString: String) {
        if report.doc.message != "" {
            let rows = report.doc.message.components(separatedBy: "\n")
            report.rowCount = rows.count
            let columns = rows[0].components(separatedBy: ",")
             report.incompatible = !(columns[1] == confirmationString)
        }
    }
    
    func parseReport(report: inout report, sectionTitle: String) {
        if report.transferred && !report.incompatible {
            let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
            var rows = report.doc.message.components(separatedBy: "\n")
            let header = "\(rows.removeFirst())"
            for row in rows {
                withAnimation{
                    self.progress += (1/Double(totalRows))
                }
                let columns = row.components(separatedBy: ",")
                if custIDs.contains(columns[0]) {
                    if data[columns[0]] == nil {
                        data[columns[0]] = "\n\(sectionTitle),\(header),\(row)\n"
                    } else {
                        if sectionTitle == "Cancelled Orders"{
                            data[columns[0]] = "\(data[columns[0]] ?? ""),\(row)\n"

                        } else {
                            data[columns[0]] = "\(data[columns[0]] ?? "")\(sectionTitle),\(header),\(row)\n"

                        }
                    }
                }
            }
        }
    }
    
    func generateReport() async {
        data.removeAll()
        exportReport.doc.message = ""
        self.progress = 0.0
        totalRows = healthReport.rowCount + ingestionReport.rowCount + liveReport.rowCount
        
        parseReport(report: &healthReport, sectionTitle: "Cancelled Orders")
        parseReport(report: &ingestionReport, sectionTitle: "Latest Ingestion")
        parseReport(report: &liveReport, sectionTitle: "Integration Live")

        
        for row in data.values {
            exportReport.doc.message.append("\(row)")
        }
        
        if exportReport.doc.message == "" {
            exportReport.doc.message.append("No Instances of any given IDs in any give files")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exportReport.transferred = true
            self.progress = 1.1
        }
    }
    
    func readyToParse() -> Bool {
        return (
            (liveReport.transferred && !liveReport.incompatible) ||
            (healthReport.transferred && !healthReport.incompatible) ||
            (ingestionReport.transferred && !ingestionReport.incompatible)
        ) && custIDs != ""
    }
}

