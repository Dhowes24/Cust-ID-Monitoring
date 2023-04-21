//
//  FileImportRow.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/8/23.
//

import SwiftUI

struct FileImportRow: View {
    @State var animateIndicator: Bool = false
    var confirmFile: @MainActor() -> ()
    var reportName: String
    var linkDestination: String
    @Binding var report: report
    @Binding var showError: Bool
    
    
    
    var body: some View {
        HStack{
            Link(destination: URL(string:linkDestination)!) {
                Text(reportName)
                    .font(.system(size: 12))
                    .frame(width: 80,alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            ZStack(alignment: .trailing){
                FileImportButton(activate: $report.transferring)
                
                FileImportIndicator(animateBool: animateIndicator ,fileImported: report.transferred, wrongFile: report.incompatible)
            }
            .frame(width: 65)
            .padding()
            Button {
                    report.doc.message = ""
                    report.rowCount = 0
                withAnimation {
                    report.transferred = false
                }
            } label: {
                Text("Remove")
                    .font(.system(size: 8))
            }

        }
        .frame( width: 250, height: 100)
        .modifier(FileImporter(
            animateIndicator: $animateIndicator,
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
            reportName: "Very Long String with Multiple Lines",
            linkDestination: "ExistingWebsite.com",
            report: .constant(report()),
            showError: .constant(true)
        )
        
    }
}
