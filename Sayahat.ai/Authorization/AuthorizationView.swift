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
    @ObservedObject var authorizationVM: AuthorizationViewModel
    @State var isShowingAlert: Bool = false
    @State var loginStatus: LoginStatus = .none
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @Binding var isLoggedIn: Bool
    var body: some View {
        NavigationStack{
            ZStack{
                
                VStack(spacing: 12){
                    Text("Log In")
                        .font(.title.bold())
                        .foregroundColor(Color.black)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Email")
                            .font(.callout.bold())
                            .foregroundColor(Color.black)
                        CustomTextField(placeholder: "example@mail.com", value: $emailText)
                        
                        
                        Text("Password")
                            .font(.callout.bold()).foregroundColor(Color.black)
                        
                        CustomTextField(placeholder: "********", value: $passwordText, isPassword: true)
                            .disableAutocorrection(true)
                        
                        //                        NavigationLink(value: "Forgot password"){
                        //                            Text("Forgot password")
                        //                                .font(.subheadline)
                        //                                .underline()
                        //                                .foregroundColor(.blue)
                        //                        }
                        HStack{
                            Spacer()
                            if authorizationVM.loginStatus == .none {
                                VStack{
                                    Button{
                                        authorizationVM.email = emailText
                                        authorizationVM.password = passwordText
                                        validateEmail()
                                        authorizationVM.authorize(isLoggedIn: $isLoggedIn)
                                    }label:{
                                        LoginButton()
                                        
                                    }
                                    NavigationLink(destination: RegistrationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn)){
                                        CustomSignUpButton()
                                    }
                                }.padding(.top, 30)
                                
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
        }
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





