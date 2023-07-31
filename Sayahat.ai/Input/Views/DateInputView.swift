//
//  DateInputView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 03.07.2023.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}


struct DateInputForm: View{
    @Binding var inputDate: Date
    var placeholder: String
    
    var body: some View{
        HStack(){
            Text(placeholder)
            Image(systemName: "calendar")
                .frame(width: 23, height: 20)
            Divider()
            DatePicker(placeholder, selection: $inputDate, displayedComponents: .date)
                .datePickerStyle(.automatic)
                .labelsHidden()
                .textFieldStyle(PlainTextFieldStyle())
                .onTapGesture{
                    withAnimation {
                        UIApplication.shared.endEditing()
                    }
                }
                .datePickerStyle(.automatic)
        }.frame(width: 340)
    }
}
    
    
