//
//  ContentView.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            HStack {
                VStack{
                    Text("Upload Redash .csv Reports")
                    
                    FileImportRow(
                        reportName: "Cancelled Orders & Validation Failures By Order",
                        importing: $vm.healthImporting,
                        imported: $vm.healthImported,
                        doc: $vm.healthDoc,
                        showError: $vm.showError,
                        wrongFile: vm.healthWrongFile,
                        confirmFile: vm.ConfirmFile)
                    
                    FileImportRow(
                        reportName: "Most Recent Menu Ingestions",
                        importing: $vm.ingestionImporting,
                        imported: $vm.ingestionImported,
                        doc: $vm.ingestionDoc,
                        showError: $vm.showError,
                        wrongFile: vm.ingestionWrongFile,
                        confirmFile: vm.ConfirmFile)
                    
                    FileImportRow(
                        reportName: "Live Locations by Partner",
                        importing: $vm.liveImporting,
                        imported: $vm.liveImported,
                        doc: $vm.liveDoc,
                        showError: $vm.showError,
                        wrongFile: vm.liveWrongFile,
                        confirmFile: vm.ConfirmFile)
                    
                }
                Spacer()
                VStack {
                    Text("Download Parsed .csv")
                    Spacer()
                    FileButton(activated: $vm.isExporting,progress: vm.progress)
                }
                .frame(width: 110, height: 180)
                .offset(y: -18)
                .modifier(FileExporter(
                    exporting: $vm.isExporting,
                    doc: $vm.exportDoc,
                    showError: $vm.showError)
                )
            }
            .padding(20)
            
            TextField("Weekly Comma Separated Cust IDs \"No Quotes\"", text: $vm.custIDs, axis: .vertical)
                .frame(height: 205)
                .lineLimit(5, reservesSpace: true)
                .padding([.leading, .trailing], 4)
                .cornerRadius(16)
            
            Button {
                Task{
                    await vm.parseDoc()
                }
            } label: {
                Text("Generate Parsed Report")
            }
            .onHover { inside in
                if inside && vm.readyToParse() {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
            .disabled(!vm.readyToParse())
        }
        .padding()
        .sheet(isPresented: $vm.showError) {
            ErrorView()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
