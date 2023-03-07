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
                    Text("Upload .csv")
                    Spacer()
                    ZStack{
                        FileButton(importOrExport: $vm.isImporting, progress: -1.0, imageName: "doc.badge.plus")
                        
                        FileImportIndicator(fileImported: vm.fileImported)
                    }
                }
                .frame( width: 110, height: 150)
                Spacer()
                VStack {
                    Text("Download Parsed .csv")
                    Spacer()
                    FileButton(importOrExport: $vm.isExporting,progress: vm.progress, imageName: "doc.text")
                }
                .frame(width: 110, height: 150)
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
                if inside && (vm.fileImported || vm.custIDs != "") {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
            .disabled(!vm.fileImported || vm.custIDs == "")
        }
        .padding()
        .sheet(isPresented: $vm.showError) {
            ErrorView()
        }
        .modifier(
            FileSystems(
                importing: $vm.isImporting,
                exporting: $vm.isExporting,
                document: $vm.document,
                showError: $vm.showError,
                fileImported: $vm.fileImported
            )
        )
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
