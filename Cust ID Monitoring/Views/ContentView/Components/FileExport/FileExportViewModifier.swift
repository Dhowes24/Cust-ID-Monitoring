//
//  FileExporter.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/8/23.
//

import Foundation

//
//  FileSystemsViewModifier.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/2/23.
//

import Foundation
import SwiftUI

struct FileExporter: ViewModifier {
    @Binding var exporting: Bool
    @Binding var doc: CSVDocument
    @Binding var showError: Bool
    
    
    func body(content: Content) -> some View {
        content
            .fileExporter(
                isPresented: $exporting,
                document: doc,
                contentType: .commaSeparatedText,
                defaultFilename: "Parsed Report",
                onCompletion: { result in
                    if case .success = result {
                    } else {
                        showError = true
                    }
                }
            )
    }
}
