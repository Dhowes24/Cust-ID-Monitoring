//
//  ErrorView.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button("X"){
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .padding()
            }
            Text("Something is not working")
                .font(.system(size: 16))
                .padding()
            
            Text("😬   🤷")
                .font(.system(size: 36))
                .padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
