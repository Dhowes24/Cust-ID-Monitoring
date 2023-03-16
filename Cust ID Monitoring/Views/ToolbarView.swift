//
//  ToolbarView.swift
//  Cust ID Monitoring
//
//  Created by Derek Howes on 3/10/23.
//

import SwiftUI

struct ToolbarView: ViewModifier {
    @Binding var infoToggle: Bool

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        infoToggle.toggle()
                    } label: {
                        Image(systemName: "info.circle")

                    }
                }
            }
    }
}
