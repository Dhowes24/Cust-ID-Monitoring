//
//  ProgressTrackerViewComponent.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 2/17/23.
//

import SwiftUI

struct ProgressTrackerViewComponent: View {
    var progress: Double
    
    var body: some View {
        if progress >= 0 && progress <= 1.0 {
            ZStack{
                Circle()
                    .stroke(
                        Color.blue.opacity(0.5),
                        lineWidth: 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.default, value: progress)
            }
            .frame(width: 80, height: 80)
        }
    }
}

struct ProgressTrackerViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProgressTrackerViewComponent(progress: 0.5)
    }
}
