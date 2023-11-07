//
//  CustomButton.swift
//  Skinsense
//
//  Created by Rainer Regan on 07/11/23.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var isDisabled: Bool = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(.darkPurple)
        .disabled(isDisabled)
    }
}

#Preview {
    CustomButton(title: "Preview Button", action: {})
}
