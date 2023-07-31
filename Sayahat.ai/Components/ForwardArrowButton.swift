//
//  ForwardArrowButton.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 11.07.2023.
//

import SwiftUI

struct ForwardArrowButton: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 64, height: 64)
                .background(Color(red: 0.2, green: 0.29, blue: 0.35))
                .cornerRadius(64)
            Image(systemName: "arrow.forward")
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
        }
    }
}

struct ForwardArrowButton_Previews: PreviewProvider {
    static var previews: some View {
        ForwardArrowButton()
    }
}
