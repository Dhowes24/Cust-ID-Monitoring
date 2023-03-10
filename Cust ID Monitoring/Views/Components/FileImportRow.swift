//
//  FileImportRow.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/8/23.
//

import SwiftUI

struct FileImportRow: View {
    var reportName: String
    @Binding var importing: Bool
    @Binding var imported: Bool
    @Binding var doc: CSVDocument
    @Binding var showError: Bool
    var wrongFile: Bool
    var confirmFile: @MainActor() -> ()
    
    var body: some View {
        HStack{
            Text(reportName)
                .font(.system(size: 12))
                .frame(width: 80)
            Spacer()
            ZStack(alignment: .trailing){
                FileImportButton(activate: $importing)
                
                FileImportIndicator(fileImported: imported, wrongFile: wrongFile)
            }
        }
        .frame( width: 200, height: 100)
        .modifier(FileImporter(
            importing: $importing,
            doc: $doc,
            showError: $showError,
            fileImported: $imported,
            confirmFile: confirmFile)
        )
    }
}

struct FileImportRow_Previews: PreviewProvider {
    static var previews: some View {
        FileImportRow(
            reportName: "Report Name",
            importing: .constant(true),
            imported: .constant(true),
            doc: .constant(CSVDocument(message: "")),
            showError: .constant(true),
            wrongFile: false) {
                print("nothing")
            }
    }
}
