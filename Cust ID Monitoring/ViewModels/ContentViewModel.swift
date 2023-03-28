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
    var parsedData = [String: String]()

    @Published var progress: Double = -0.1
    @Published var showError: Bool = false
    var totalRows: Int = 0
    
    @Published var healthReport: report = report()
    @Published var ingestionReport: report = report()
    @Published var liveReport: report = report()
    @Published var transactingReport: report = report()
    @Published var exportReport: report = report()
    
    func validateReports() {
        confirmReport(report: &healthReport, confirmationString: "order_number")
        confirmReport(report: &ingestionReport, confirmationString: "request_id")
        confirmReport(report: &liveReport, confirmationString: "merchant_status")
        confirmReport(report: &transactingReport, confirmationString: "first_order_date_ct\r")

    }
    
    func confirmReport(report: inout report, confirmationString: String) {
        if report.doc.message != "" {
            let rows = report.doc.message.components(separatedBy: "\n")
            report.rowCount = rows.count
            let columns = rows[0].components(separatedBy: ",")
            report.incompatible = !(columns[1].components(separatedBy: "\n")[0] == confirmationString)
        }
    }
    
    func parseReport(report: inout report, sectionTitle: String, custIDs: [String]) {
        if report.transferred && !report.incompatible {
            var rows = report.doc.message.components(separatedBy: "\n")
            let header = "\(rows.removeFirst())"
            for row in rows {
                withAnimation{
                    self.progress += (1/Double(totalRows))
                }
                let columns = row.components(separatedBy: ",")
                if custIDs.contains(columns[0]) && columns[1].count != 1 {
                    if parsedData[columns[0]] == nil {
                        parsedData[columns[0]] = "\n\(sectionTitle),\(header),\(row)\n"
                        report.dict[columns[0]] = true
                    } else {
                        if sectionTitle == "Cancelled Orders"{
                            parsedData[columns[0]] = "\(parsedData[columns[0]] ?? ""),\(row)\n"
                        } else {
                            parsedData[columns[0]] = "\(parsedData[columns[0]] ?? "")\(sectionTitle),\(header),\(row)\n"
                            report.dict[columns[0]] = true
                        }
                    }
                }
            }
        }
    }
    
    func generateReport() async {
        parsedData.removeAll()
        exportReport.doc.message = ""
        healthReport.dict.removeAll()
        ingestionReport.dict.removeAll()
        liveReport.dict.removeAll()
        transactingReport.dict.removeAll()
        self.progress = 0.0
        
        totalRows = healthReport.rowCount + ingestionReport.rowCount + liveReport.rowCount
        let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
        for id in custIDs {
            healthReport.dict[id] = false
            ingestionReport.dict[id] = false
            liveReport.dict[id] = false
            transactingReport.dict[id]=false
        }
        
        parseReport(report: &healthReport, sectionTitle: "Cancelled Orders", custIDs: custIDs)
        parseReport(report: &ingestionReport, sectionTitle: "Latest Ingestion", custIDs: custIDs)
        parseReport(report: &liveReport, sectionTitle: "Integration Live", custIDs: custIDs)
        parseReport(report: &transactingReport, sectionTitle: "First Transaction", custIDs: custIDs)


        
        for row in parsedData.values {
            exportReport.doc.message.append("\(row)")
        }
        
        notFoundIds(header: "Ids Without Cancelled Orders", report: healthReport)
        notFoundIds(header: "Ids Without Menu Ingestions", report: ingestionReport)
        notFoundIds(header: "Ids Not Currently Live", report: liveReport)
        notFoundIds(header: "Ids Not Currently Transacting", report: transactingReport)

        
        if exportReport.doc.message == "" {
            exportReport.doc.message.append("No Instances of any given IDs in any give files")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exportReport.transferred = true
            self.progress = 1.1
        }
    }
    
    func notFoundIds(header: String, report: report) {
        if report.doc.message != "" {
            exportReport.doc.message.append("\n\(header)\n")
            for (id, present) in report.dict {
                if !present {
                    exportReport.doc.message.append(",\(id)\n")
                }
            }
            exportReport.doc.message.append("\n")
        }
    }
    
    func readyToParse() -> Bool {
        return (
            (liveReport.transferred && !liveReport.incompatible) ||
            (healthReport.transferred && !healthReport.incompatible) ||
            (ingestionReport.transferred && !ingestionReport.incompatible) ||
            (transactingReport.transferred && !transactingReport.incompatible)
        ) && custIDs != ""
    }
}

