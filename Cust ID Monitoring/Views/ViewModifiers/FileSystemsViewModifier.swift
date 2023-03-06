//
//  FileSystemsViewModifier.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/2/23.
//

import Foundation
import SwiftUI

struct FileSystems: ViewModifier {
    @Binding var importing: Bool
    @Binding var exporting: Bool
    @Binding var document: CSVDocument
    @Binding var showError: Bool
    @Binding var fileImported: Bool

    func body(content: Content) -> some View {
        content
            .fileExporter(
                isPresented: $exporting,
                document: document,
                contentType: .commaSeparatedText,
                defaultFilename: "Parsed Report",
                onCompletion: { result in
                    if case .success = result {
                    } else {
                        showError = true
                    }
                }
            )
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }

                    document.message = message
                    fileImported = true
                } catch {
                    showError = true
                }
            }
    }
}
