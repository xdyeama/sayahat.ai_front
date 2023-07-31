//
//  ForgotPasswordView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 06.07.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var authorizationVM: AuthorizationViewModel
    @State var emailText: String = ""
    var body: some View {
        ZStack{
            if (colorScheme == .light){
                LinearGradient(colors:[.cyan, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
            }else{
                LinearGradient(colors:[Color(red: 15/255, green: 12/255, blue: 41/255), Color(red: 48/255, green: 43/255, blue: 99/255), Color(red: 36/255, green: 36/255, blue: 62/255)], startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea(.all)
            }
            VStack(spacing: 12){
                Text("Forgot Password?")
                    .font(.title.bold())
                    .foregroundColor(Color.white)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("Email")
                        .font(.callout.bold())
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: "example@mail.com", value: $emailText)

                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .padding(.vertical, 12)
                        Text("Restore password")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("LoginButtonText"))
                            .padding(.vertical, 12)
                            .background(Color("LoginButtonBg"))
                            .frame(maxWidth: .infinity)

                    }
                    .padding(.top, 30)
                    .onTapGesture {
                        authorizationVM.restorePassEmail = emailText
                        authorizationVM.restorePassword()
                    }
                }
                
            }
            .padding(.horizontal, 30)
            .padding(.top, 35)
            .padding(.bottom, 25)
            .background{
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(Color.white.opacity(0.15))
                    .backgroundStyle(.ultraThinMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            self.endEditing()
        }

    }
}

extension ForgotPasswordView{
    func CustomTextField(placeholder: String, value: Binding<String>, isPassword: Bool = false) -> some View{
        Group {
            if isPassword{
                SecureField(placeholder, text: value)
                    .disableAutocorrection(true)

            }else{
                TextField(placeholder, text: value)
                    .disableAutocorrection(true)

            }
            
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .foregroundColor(.white)
        .background(Color("TextField"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
    }
}
