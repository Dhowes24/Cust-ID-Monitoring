//
//  FileImportIndicator.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/21/23.
//

import SwiftUI

struct FileImportIndicator: View {
    let fileImported: Bool
    @State private var checkScale: Double = 0.0
    
    var body: some View {
        if (fileImported) {
                HStack(alignment: .top){
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .foregroundColor(.green)
                        .scaleEffect(checkScale)
                        .animation(.interpolatingSpring(stiffness: 170, damping: 13), value: checkScale)
                }
                .frame(height: 130,alignment: .top)
                Spacer()
            .onAppear {
                withAnimation {
                    self.checkScale = 1.0
                }
            }
        } else {
            Text("")
                .onAppear(){
                    print("anything")
                    self.checkScale = 0.0
                }
        }
    }
}

struct FileImportIndicator_Previews: PreviewProvider {
    static var previews: some View {
        FileImportIndicator(fileImported: true)
    }
}
