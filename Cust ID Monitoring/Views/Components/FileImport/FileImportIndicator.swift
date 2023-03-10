//
//  FileImportIndicator.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/21/23.
//

import SwiftUI

struct FileImportIndicator: View {
    let fileImported: Bool
    var wrongFile: Bool
    @State private var checkScale: Double = 0.0
    
    var body: some View {
        if (fileImported) {
                HStack(alignment: .top){
                    if wrongFile {
                        Text("This Report Has Incorrect Column Headers")
                            .font(.system(size: 8))
                            .foregroundColor(.red)
                            .frame(width: 40)
                            .offset(x:0, y:10)

                    }
                    Spacer()
                    ZStack{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 20)
                            .scaleEffect(checkScale)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 13), value: checkScale)
                        if wrongFile {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundColor(.red)
                                .scaleEffect(checkScale)
                                .animation(.interpolatingSpring(stiffness: 170, damping: 13), value: checkScale)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundColor(.green)
                                .scaleEffect(checkScale)
                                .animation(.interpolatingSpring(stiffness: 170, damping: 13), value: checkScale)
                        }
                    }
                }
                .frame(height: 80,alignment: .top)
                Spacer()
            .onAppear {
                withAnimation {
                    self.checkScale = 1.0
                }
            }
            .onChange(of: wrongFile) { _ in
                self.checkScale = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.checkScale = 1.0
                }
            }
        } else {
            Text("")
                .onAppear(){
                    self.checkScale = 0.0
                }
        }
    }
}

struct FileImportIndicator_Previews: PreviewProvider {
    static var previews: some View {
        FileImportIndicator(fileImported: true, wrongFile: true)
    }
}
