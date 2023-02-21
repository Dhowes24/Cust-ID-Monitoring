//
//  CSVDocument.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct CSVDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var message: String
    
    init(message:String) {
        self.message = message
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
    
}
