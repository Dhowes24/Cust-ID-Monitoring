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
    var text: String
    var destination: String
    var body: some View {
        HStack{
            Circle()
                .frame(width: 5)
            Link(text,
                 destination: URL(string:destination)!)
                .font(.system(size: 10))
        }
    }
}

struct NumberedPoint: View {
    let number: String
    var body: some View {
        HStack{
            Text(number)
                .font(.system(size: 15))
                .fontWeight(.bold)
            Circle()
                .frame(width: 5)
                .offset(x: -3, y: 5)
        }
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
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.borderless)
                .padding()
                
            }
            Text("Application Info")
                .fontWeight(.bold)
                .padding(5)

            Text("This application can be used to parse through Redash Reports and extract the weekly Cust IDs you are monitoring")
                .padding([.trailing,.leading], 5)
                .fixedSize(horizontal: false, vertical: true)

            
            Text("Requirements")
                .fontWeight(.bold)
                .padding(5)
            
            HStack(alignment: .top){
                NumberedPoint(number: "1")
                VStack(alignment: .leading){
                    Text("There are four reports you can upload. At least one report is mandatory for the app to work, but none are specifically required ")
                    
                    VStack(alignment: .leading){
                        BulletPoint(text: "Integration Health Detail -> Cancelled Orders & Validation Failures By Order",
                        destination:                                     "https://redash.gdp.data.grubhub.com/dashboard/integration-health?p_Begin_Date=2022-08-22&p_End_Date=2022-08-26&p_Brand=%5B%22JETS%20PIZZA%22%5D&p_w17414_Cancelled_Order_%3E%3D=0&p_w17602_Brand=%5B%22PORTILLOS%22%5D&p_w17414_Use%20Brand=TRUE&p_w17414_Use%20POS%20Config=FALSE&p_w17414_POS%20Config=%5B%22TOASTSMB%22%5D&p_Cancelled_Order_%3E%3D=0&p_Use%20Brand=FALSE&p_Use%20POS%20Config=TRUE&p_POS%20Config=%5B%22ADKMERCHANTS%22%5D&p_w17421_Use%20Brand=TRUE&p_w17421_Use%20POS%20Config=FALSE&p_w17421_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17422_Use%20Brand=TRUE&p_w17422_Use%20POS%20Config=FALSE&p_w17422_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17419_Use%20Brand=TRUE&p_w17419_Use%20POS%20Config=FALSE&p_w17419_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17423_Use%20Brand=TRUE&p_w17423_Use%20POS%20Config=FALSE&p_w17423_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17420_Use%20Brand=TRUE&p_w17420_Use%20POS%20Config=FALSE&p_w17420_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17472_Use%20Brand=TRUE&p_w17472_Use%20POS%20Config=FALSE&p_w17472_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17638_Use%20Brand=TRUE&p_w17638_Use%20POS%20Config=FALSE&p_w17638_POS%20Config=%5B%22TOASTSMB%22%5D&p_w17640_Cancelled_Order_%3E%3D=0&p_w17993_Cancelled_Order_%3E%3D=0&p_w19213_Cancelled_Order_%3E%3D=0&p_w20855_Cancelled_Order_%3E%3D=0")
                        BulletPoint(text: "Live Locations by Partner",
                        destination: "https://redash.gdp.data.grubhub.com/queries/125075/source?p_Integration%20Partner%20ID=1")
                        BulletPoint(text: "Most Recent Menu Ingestions by Cust_ID",
                        destination:"https://redash.gdp.data.grubhub.com/queries/116664/source?p_Cust_ID=1")
                        BulletPoint(text: "GoPuff CIDs Received Orders",
                        destination: "https://redash.gdp.data.grubhub.com/queries/141089/source")
                        
                    }
                    .padding(.vertical, 5)
                    
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
                .fixedSize(horizontal: false, vertical: true)
                .modifier(BackgroundRectangle())
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            HStack(alignment: .top){
                NumberedPoint(number: "2")
                VStack(alignment: .leading){
                    Text("The text input field must be populated to enabled the 'Generate Parsed Report' Button below")
                        .padding(.vertical ,5)
                    Text("All whitespace and new lines will be filtered out of the message when parsing, so there is no need to go through and clean it up")
                        .padding(.vertical ,5)
                }
                .fixedSize(horizontal: false, vertical: true)
                .modifier(BackgroundRectangle())
            }
            .frame(maxWidth: .infinity)
            .padding()
            
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
