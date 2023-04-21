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
    
    var summaryReportDict = [String: String]()
    
    func confirmReport(report: inout report, confirmationString: String) {
        if report.doc.message != "" {
            let rows = report.doc.message.components(separatedBy: "\n")
            report.rowCount = rows.count
            let columns = rows[0].components(separatedBy: ",")
            report.incompatible = !(columns[1].components(separatedBy: "\n")[0] == confirmationString)
        }
    }
    
    func generateReport() async {
        resetValues()
        
        let custIDs = custIDs.trimmingAllSpaces().components(separatedBy: ",")
        for id in custIDs {
            healthReport.dict[id] = 0
            ingestionReport.dict[id] = 0
            liveReport.dict[id] = 0
            transactingReport.dict[id]=0
        }
        
        parseReport(report: &healthReport, sectionTitle: "Cancelled Orders", custIDs: custIDs)
        parseReport(report: &ingestionReport, sectionTitle: "Latest Ingestion", custIDs: custIDs)
        parseReport(report: &liveReport, sectionTitle: "Integration Live", custIDs: custIDs)
        parseReport(report: &transactingReport, sectionTitle: "First Transaction", custIDs: custIDs)
        for row in parsedData.values {
            exportReport.doc.message.append("\(row)")
        }
        
        summarizeHealthCheck()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.exportReport.transferred = true
            self.progress = 1.1
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
                        report.dict[columns[0]] = 1
                    } else {
                        if sectionTitle == "Cancelled Orders"{
                            parsedData[columns[0]] = "\(parsedData[columns[0]] ?? ""),\(row)\n"
                        } else {
                            parsedData[columns[0]] = "\(parsedData[columns[0]] ?? "")\(sectionTitle),\(header),\(row)\n"
                        }
                        report.dict[columns[0]] = (report.dict[columns[0]] ?? 0) + 1
                        
                    }
                }
            }
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
    
    func resetValues() {
        parsedData.removeAll()
        exportReport.doc.message = ""
        healthReport.dict.removeAll()
        ingestionReport.dict.removeAll()
        liveReport.dict.removeAll()
        transactingReport.dict.removeAll()
        self.progress = 0.0
        totalRows = healthReport.rowCount + ingestionReport.rowCount + liveReport.rowCount
    }
    
    func summarizeHealthCheck() {
        summarizeIds(message: "Cancelled Order Count", report: healthReport, cancelledOrdersReport: true)
        summarizeIds(message: "No Menu Ingestion", report: ingestionReport)
        summarizeIds(message: "Not Live", report: liveReport)
        summarizeIds(message: "Not Transacting", report: transactingReport)
        
        exportReport.doc.message.append("\nHealth Check Summary\n")
        for (_, message) in summaryReportDict {
            exportReport.doc.message.append("\(message)\n")
        }
        
        if exportReport.doc.message == "" {
            exportReport.doc.message.append("No Instances of any given IDs in any give files")
        }
    }
    
    func summarizeIds(message: String, report: report, cancelledOrdersReport: Bool = false) {
        if report.doc.message != "" {
            for (id, count) in report.dict {
                if cancelledOrdersReport && count > 0 {
                    if summaryReportDict[id] == nil {
                        summaryReportDict[id] = "\(id), \(message): \(count)"
                    } else {
                        summaryReportDict[id] = "\(summaryReportDict[id] ?? "Error"), \(message): \(count)"
                    }
                }
                else if !cancelledOrdersReport && count == 0 {
                    if summaryReportDict[id] == nil {
                        summaryReportDict[id] = "\(id), \(message)"
                    } else {
                        summaryReportDict[id] = "\(summaryReportDict[id] ?? "Error"), \(message)"
                    }
                }
            }
        }
    }
    
    func validateReports() {
        confirmReport(report: &healthReport, confirmationString: "order_number")
        confirmReport(report: &ingestionReport, confirmationString: "request_id")
        confirmReport(report: &liveReport, confirmationString: "merchant_status")
        confirmReport(report: &transactingReport, confirmationString: "first_order_date_ct\r")
        
    }
}


