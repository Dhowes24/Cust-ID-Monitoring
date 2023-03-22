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
                        linkDestination:
                            "https://redash.gdp.data.grubhub.com/dashboard/integration-health?p_Begin_Date=2022-08-22&p_End_Date=2022-08-26&p_Brand=%5B%22JETS%20PIZZA%22%5D&p_w17414_Cancelled_Order_%3E%3D=0&p_w17602_Brand=%5B%22PORTILLOS%22%5D&p_w17414_Use%20Brand=TRUE&p_w17414_Use%20POS%20Config=FALSE&p_w17414_POS%20Config=%5B%22TOASTSMB%22%5D&p_Cancelled_Order_%3E%3D=0&p_Use%20Brand=FALSE&p_Use%20POS%20Config=TRUE&p_POS%20Config=%5B%22ADKMERCHANTS%22%5D&p_w17421_Use%20Brand=TRUE&p_w17421_Use%20POS%20Config=FALSE&p_w17421_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17422_Use%20Brand=TRUE&p_w17422_Use%20POS%20Config=FALSE&p_w17422_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17419_Use%20Brand=TRUE&p_w17419_Use%20POS%20Config=FALSE&p_w17419_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17423_Use%20Brand=TRUE&p_w17423_Use%20POS%20Config=FALSE&p_w17423_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17420_Use%20Brand=TRUE&p_w17420_Use%20POS%20Config=FALSE&p_w17420_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17472_Use%20Brand=TRUE&p_w17472_Use%20POS%20Config=FALSE&p_w17472_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17638_Use%20Brand=TRUE&p_w17638_Use%20POS%20Config=FALSE&p_w17638_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17640_Cancelled_Order_%3E%3D=0&p_w17993_Cancelled_Order_%3E%3D=0&p_w19213_Cancelled_Order_%3E%3D=0&p_w20855_Cancelled_Order_%3E%3D=0",
                        report: $vm.healthReport,
                        showError: $vm.showError)
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "Most Recent Menu Ingestions",
                        linkDestination:
                            "https://redash.gdp.data.grubhub.com/queries/116664/source?p_Cust_ID=1",
                        report: $vm.ingestionReport,
                        showError: $vm.showError)
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "Live Locations by Partner",
                        linkDestination:                         "https://redash.gdp.data.grubhub.com/queries/125075/source?p_Integration%20Partner%20ID=1",
                        report: $vm.liveReport,
                        showError: $vm.showError)
                    FileImportRow(
                        confirmFile: vm.validateReports,
                        reportName: "CIDs Received Orders",
                        linkDestination: "https://redash.gdp.data.grubhub.com/queries/141089/source",
                        report: $vm.transactingReport,
                        showError: $vm.showError)
                    
                }
                Spacer()
                VStack {
                    Text("Download Parsed .csv")
                    Spacer()
                    FileExportButton(activated: $vm.exportReport.transferring,progress: vm.progress)
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
