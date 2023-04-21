//
//  ContentView.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var vm = ContentViewModel()
    @State var infoToggle: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack{
                    Text("Upload Redash .csv Reports")
                    
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "Cancelled Orders & Validation Failures By Order",
                        linkDestination: cancelledOrderRedash,
                        report: $vm.healthReport,
                        showError: $vm.showError)
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "Most Recent Menu Ingestions",
                        linkDestination: menuIngestionRedash,
                        report: $vm.ingestionReport,
                        showError: $vm.showError)
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "Live Locations by Partner",
                        linkDestination: liveLocationsRedash,
                        report: $vm.liveReport,
                        showError: $vm.showError)
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "CIDs Received Orders",
                        linkDestination: receivedOrdersRedash,
                        report: $vm.transactingReport,
                        showError: $vm.showError)
                    
                }
                Spacer()
                VStack {
                    Text("Download Parsed .csv")
                    Spacer()
                    FileExportButton(animated: vm.animateExportButton, activated: $vm.exportReport.transferring,progress: vm.progress)
                }
                .frame(width: 110, height: 180)
                .offset(y: -18)
                .modifier(FileExporter(
                    exporting: $vm.exportReport.transferring,
                    doc: $vm.exportReport.doc,
                    showError: $vm.showError)
                )
            }
            .padding(.horizontal, 20)
            
            TextField("Weekly Comma Separated Cust IDs \"No Quotes\"", text: $vm.custIDs, axis: .vertical)
                .frame(height: 205)
                .lineLimit(5, reservesSpace: true)
                .padding([.leading, .trailing], 4)
                .cornerRadius(16)
            
            Button {
                Task{
                    await vm.generateReport()
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
        .sheet(isPresented: $infoToggle, content: {
            InfoView()
        })
        .modifier(ToolbarView(infoToggle: $infoToggle))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
