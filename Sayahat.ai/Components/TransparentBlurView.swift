//
//  TransparentBlurView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 23.07.2023.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context){
        DispatchQueue.main.async{
            if let backdropLayer = uiView.layer.sublayers?.first{
                if removeAllFilters {
                    backdropLayer.filters = []
                }else{
                    backdropLayer.filters?.removeAll(where: {filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}

struct TransparentBlurView_Previews: PreviewProvider {
    static var previews: some View {
        TransparentBlurView()
    }
}
