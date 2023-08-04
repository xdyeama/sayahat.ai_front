//
//  ForgotPasswordView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 06.07.2023.
//

import SwiftUI

enum ResponseStatus{
    case none
    case success
    case userNotExist
    case failure
}

struct ForgotPasswordView: View {
    @EnvironmentObject var authorizationVM: AuthorizationViewModel
    @State var responseStatus: ResponseStatus = ResponseStatus.none
    @State var emailText: String = ""
    var body: some View {
        ZStack{
            VStack(spacing: 12){
                VStack(spacing: 10){
                    Image("app_logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                    Text("SayahatAI")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                }
                
                VStack(alignment: .leading, spacing: 8){
                    Text("Email")
                        .font(.callout.bold())
                        .foregroundColor(Color.black)
                    CustomTextField(placeholder: "example@mail.com", value: $emailText)

                
                    ZStack{
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .padding(.vertical, 12)
                        Text("Get new password")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("LoginButtonText"))
                            .padding(.vertical, 12)
                            .background(Color("LoginButtonBg"))
                            .frame(maxWidth: .infinity)

                    }
                    .padding(.top, 10)
                    .onTapGesture {
                        authorizationVM.restorePassEmail = emailText
                        authorizationVM.restorePassword($responseStatus)
                    }
                    if responseStatus == ResponseStatus.success{
                        Text("The email with a new password has been sent to the provided email")
                            .foregroundColor(.green)
                    }else if responseStatus == ResponseStatus.userNotExist{
                        Text("The user with such email does not exist")
                            .foregroundColor(.yellow)
                    }else if responseStatus == ResponseStatus.failure{
                        Text("Could not sent message to the \(emailText). Please try again later")
                            .foregroundColor(.red)
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
        .foregroundColor(.black)
        .textInputAutocapitalization(.never)
        .background(Color("TextField"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
    }
}
