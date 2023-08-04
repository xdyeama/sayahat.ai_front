//
//  AuthorizationView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 05.07.2023.
//

import SwiftUI
import AuthenticationServices


struct CustomSignUpButton: View{
    var body: some View {
        Text("Register")
            .foregroundColor(.white)
            .font(.callout)
            .fontWeight(.bold)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(8)
    }
}

struct LoginButton: View{
    var body: some View {
        Text("Log in")
            .foregroundColor(.black)
            .font(.callout)
            .fontWeight(.bold)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
            )
        
    }
}


enum LoginStatus{
    case none, loading, success, failure
}


struct AuthorizationView: View {
    @EnvironmentObject var authorizationVM: AuthorizationViewModel
    @State var isShowingAlert: Bool = false
    @State var loginStatus: LoginStatus = .none
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State var showPassword: Bool = false
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
                    //                    Text("Log In")
                    //                        .font(.title.bold())
                    //                        .foregroundColor(Color.black)
                    //
                    VStack(alignment: .leading, spacing: 8){
                        Text("Email")
                            .font(.callout.bold())
                            .foregroundColor(Color.black)
                        CustomTextField(placeholder: "example@mail.com", value: $emailText, showPassword: $showPassword)
                        
                        
                        Text("Password")
                            .font(.callout.bold()).foregroundColor(Color.black)
                        
                        CustomTextField(placeholder: "********", value: $passwordText, isPassword: true, showPassword: $showPassword)
                            .disableAutocorrection(true)
                        
                        NavigationLink(value: SelectionState.string("forgot password")){
                            Text("Forgot password")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        HStack{
                            Spacer()
                            if authorizationVM.loginStatus == .none {
                                VStack{
                                    Button{
                                        authorizationVM.email = emailText
                                        authorizationVM.password = passwordText
                                        validateEmail()
                                        authorizationVM.authorize()
                                    }label:{
                                        LoginButton()
                                        
                                    }
                                    HStack{
                                        Text("Don't have account?")
                                        NavigationLink(value: SelectionState.string("Registration")){
                                            Text("Register")
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }.padding(.top, 10)
                                
                            }else if authorizationVM.loginStatus == .loading{
                                ProgressView()
                                    .padding()
                            }else if authorizationVM.loginStatus == .success{
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                                    .padding()
                            }else if authorizationVM.loginStatus == .failure{
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            Spacer()
                        }
                        
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Invalid Email"), message: Text("Please enter a valid email address."), dismissButton: .default(Text("OK")))
        }
    }
}


extension AuthorizationView{
    func CustomTextField(placeholder: String, value: Binding<String>, isPassword: Bool = false, showPassword: Binding<Bool>) -> some View{
        Group {
            if isPassword{
                if showPassword.wrappedValue {
                    HStack{
                        TextField(placeholder, text: value)
                            .disableAutocorrection(true)
                        Image(systemName: "eye.slash")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(.gray)
                            .onTapGesture{
                                showPassword.wrappedValue.toggle()
                            }
                    }
                } else {
                    HStack{
                        SecureField(placeholder, text: value)
                            .disableAutocorrection(true)
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(.gray)
                            .onTapGesture{
                                showPassword.wrappedValue.toggle()
                            }
                    }
                }
            }else{
                TextField(placeholder, text: value)
                    .disableAutocorrection(true)
                
            }
            
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .foregroundColor(.black)
        .background(Color("TextField"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .textInputAutocapitalization(.never)
    }
    
    
    private func hideKeyboard() {
        // End editing by resigning the first responder status
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    func validateEmail() {
        if isValidEmail(emailText) {
            // Email format is valid
            print("Valid email: \(emailText)")
        } else {
            // Show alert for invalid email format
            isShowingAlert = true
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Simple email validation using regular expression
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}





