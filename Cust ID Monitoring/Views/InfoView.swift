//
//  InfoView.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/10/23.
//

import SwiftUI

struct BackgroundRectangle: ViewModifier {
    let backgroundColor = Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
    
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(backgroundColor)
                    .shadow(radius: 5,x: 5, y:3)
            )
    }
    
}

struct BulletPoint: View {
    var text:String
    var body: some View {
        HStack{
            Circle()
                .frame(width: 5)
            Text(text)
                .font(.system(size: 10))
        }
    }
}

struct NumberedPoint: View {
    let number: String
    var body: some View {
        Text(number)
            .font(.system(size: 15))
            .fontWeight(.bold)
        Circle()
            .frame(width: 5)
            .offset(x: -3, y: 10)
    }
}

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack(alignment: .top){
                Spacer()
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
                .buttonStyle(.borderless)
                .padding()
                
            }
            Text("Application Info")
                .fontWeight(.bold)
                .padding(5)

            Text("This application can be used to parse through Redash Reports and extract the weekly Cust IDs you are monitoring")
                .padding([.trailing,.leading], 5)

            
            Text("Requirements")
                .fontWeight(.bold)
                .padding(5)
            
            HStack(alignment: .top){
                NumberedPoint(number: "1")
                VStack(alignment: .leading){
                    Text("There are three reports you can upload. At least one report is mandatory for the app to work, but none are specifically required ")
                    
                    VStack(alignment: .leading){
                        BulletPoint(text: "Integration Health Detail -> Cancelled Orders & Validation Failures By Order")
                        BulletPoint(text: "Live Locations by Partner")
                        BulletPoint(text: "Most Recent Menu Ingestions by Cust_ID")
                        
                    }
                    .padding([.top,.bottom], 5)
                    
                    Text("Upon upload the file will either be marked as compatible or not")
                    
                    HStack{
                        Spacer()
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    
                    Text("The app looks through the .CSV headers to make this distinction")
                }
                .modifier(BackgroundRectangle())
                
            }
            .frame(width: 400)
            
            HStack(alignment: .top){
                NumberedPoint(number: "2")
                VStack(alignment: .leading){
                    Text("The text input field must be populated to enabled the 'Generate Parsed Report' Button below")
                        .padding(5)
                    Text("All Whitespace and commas will be filtered out of the message when parsing, so there is no need to go through and clean it up")
                        .padding(5)
                }.modifier(BackgroundRectangle())
            }
            .frame(width: 400)
            
            Spacer()
        }
        .frame(width: 450, height: 600)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
