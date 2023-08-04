//
//  NoNetworkView.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 03.08.2023.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 75, height: 75)
                .foregroundColor(.red)
            
            Text("Looks like you are not connected to the network. Check your network connectivity and try again.")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                
        }
        .padding()
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetworkView()
    }
}
