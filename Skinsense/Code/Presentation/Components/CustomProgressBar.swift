//
//  CustomProgressBar.swift
//  Skinsense
//
//  Created by Shelamines Julianni on 09/11/23.
//

import SwiftUI

struct CustomProgressBar: View {
    var text: String
    var body: some View {
        ZStack{
            ZStack{
                Rectangle()
                    .frame(height: 10)
            }
            Text(text)
                .font(.body)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.lightPurple)
        .cornerRadius(10)
    }
}

#Preview {
    CustomProgressBar(text: "test")
}
