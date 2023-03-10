//
//  ReportModel.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/10/23.
//

import Foundation

struct report {
    var doc: CSVDocument = CSVDocument(message: "")
    var transferring: Bool = false
    var transferred: Bool = false
    var incompatible: Bool = false
    var rowCount: Int = 0
}
