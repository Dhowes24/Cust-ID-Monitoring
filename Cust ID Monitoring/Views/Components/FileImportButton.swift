//
//  FileImportButton.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/8/23.
//
//
//  FileButton.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import Foundation
import SwiftUI

struct importButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color(red: 224/255, green: 224/255, blue: 224/255))
                    .opacity(configuration.isPressed ? 0.0 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatCount(0),
                        value: configuration.isPressed
                    )
            }
    }
}


struct FileImportButton: View {
    @Binding var activate: Bool
    
    var body: some View {
        
        
        Button {
            activate.toggle()
        } label: {
            ZStack{
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(red: 224/255, green: 224/255, blue: 224/255))
                    .frame(width: 65,height: 70)
                
                
                Image(systemName: "doc.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45)
                    .foregroundColor(.blue)
                
            }
        }
        .buttonStyle(MyButtonStyle())



    }
}



struct FileImportButton_Previews: PreviewProvider {
    static var previews: some View {
        FileImportButton(activate: .constant(false))
    }
}
