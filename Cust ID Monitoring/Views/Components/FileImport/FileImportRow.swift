//
//  FileImportRow.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/8/23.
//

import SwiftUI

struct FileImportRow: View {
    var confirmFile: @MainActor() -> ()
    var reportName: String
    @Binding var report: report
    @Binding var showError: Bool
    
    
    
    var body: some View {
        HStack{
            Text(reportName)
                .font(.system(size: 12))
                .frame(width: 80)
            Spacer()
            ZStack(alignment: .trailing){
                FileImportButton(activate: $report.transferring)
                
                FileImportIndicator(fileImported: report.transferred, wrongFile: report.incompatible)
            }
        }
        .frame( width: 200, height: 100)
        .modifier(FileImporter(
            importing: $report.transferring,
            doc: $report.doc,
            showError: $showError,
            fileImported: $report.transferred,
            confirmFile: confirmFile)
        )
    }
}

struct FileImportRow_Previews: PreviewProvider {
    static var previews: some View {
        FileImportRow(
            confirmFile: {
                print("nothing")
            },
            reportName: "String",
            report: .constant(report()),
            showError: .constant(false)
        )
        
    }
}
