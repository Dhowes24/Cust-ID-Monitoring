//
//  FileButton.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import Foundation
import SwiftUI

struct ExportButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.default, value: configuration.isPressed)
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(red: 224/255, green: 224/255, blue: 224/255))
                    .scaleEffect(configuration.isPressed ? 1.5 : 1.0)
                    .opacity(configuration.isPressed ? 0.0 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatCount(0),
                        value: configuration.isPressed
                    )
            }
    }
}

struct FileExportButton: View {
    var animated: Bool
    @Binding var activated: Bool
    var progress: Double
    @State var shrink = 1.0
    @State var grow = 0.0
    
    var body: some View {
        
        Button {
            activated = true
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(red: 224/255, green: 224/255, blue: 224/255))
                    .frame(width: 100,height: 110)
                if(progress >= 1) {
                    Image(systemName: "arrow.down.doc.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .padding()
                        .scaleEffect(grow)
                        .foregroundColor(.blue)
                        .onAppear {
                            withAnimation {
                                grow = 1.0
                            }
                        }
                } else {
                    Image(systemName: "doc.text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding()
                        .scaleEffect(shrink)
                        .foregroundColor( progress == -0.1 ? .gray : .blue)
                        .onDisappear {
                            withAnimation {
                                shrink = 0.0
                            }
                        }
                }
                ProgressTrackerViewComponent(progress: progress)
            }
            .onHover { inside in
                if inside && progress != -0.1 {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
            .onChange(of: progress) { _ in
                if(progress >= 1) {
                    withAnimation {
                        grow = 1.3
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.grow = 1.0
                        }
                    }
                }
            }
        }
        .disabled(progress == -0.1)
        .buttonStyle(ExportButtonStyle())
    }
}

struct FileExportButton_Previews: PreviewProvider {
    static var previews: some View {
        FileExportButton(animated: true, activated: .constant(false),progress: -0.1)
    }
}
