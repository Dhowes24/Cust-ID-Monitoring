//
//  FileSystemsViewModifier.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/2/23.
//

import Foundation
import SwiftUI

struct FileImporter: ViewModifier {
    
    @Binding var animateIndicator: Bool
    @Binding var importing: Bool
    @Binding var doc: CSVDocument
    @Binding var showError: Bool
    @Binding var fileImported: Bool
    var confirmFile: @MainActor() -> ()
    

    func body(content: Content) -> some View {
        content
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }

                    doc.message = message
                    confirmFile()
                    fileImported = true
                    withAnimation {
                        animateIndicator.toggle()
                    }
                } catch {
                    showError = true
                }
            }
    }
}
