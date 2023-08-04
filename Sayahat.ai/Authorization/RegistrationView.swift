//
//  RegistrationView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 06.07.2023.
//

import SwiftUI

enum RegisterStatus{
    case none, loading, success, failure
}


struct RegistrationView: View {
    @EnvironmentObject var authorizationVM: AuthorizationViewModel
    @State var isEmailInvalid: Bool = false
    @State var passwordsDontMatch: Bool = false
    @State var fullName: String = ""
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State var passwordConfirm: String = ""
    @State var isRegistered: Bool = false
    @State var showPassword: Bool = false
    @State var showConfirmPassword: Bool = false
    var body: some View {
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
                CustomTextField(placeholder: "example@mail.com", value: $emailText, showPassword: $showPassword)
                
                Text("Password")
                    .font(.callout.bold())
                    .foregroundColor(Color.black)
                CustomTextField(placeholder: "********", value: $passwordText, isPassword: true, showPassword: $showPassword)
                
                Text("Confirm Password")
                    .font(.callout.bold())
                    .foregroundColor(Color.black)
                CustomTextField(placeholder: "********", value: $passwordConfirm, isPassword: true, showPassword: $showConfirmPassword)
                
                HStack{
                    Text("Already a member? ")
                        .font(.subheadline)
                    NavigationLink(value: SelectionState.string("Authorization")){
                        Text("Sign in")
                            .font(.subheadline)
                            .underline()
                            .foregroundColor(.blue)
                    }
                }
                if authorizationVM.registerStatus == .none{
                    NavigationLink(value: SelectionState.string("Authorization")){
                        Button{
                            validateEmail()
                            if emailText != "" && passwordText != "" && passwordConfirm != ""{
                                if passwordText == passwordConfirm{
                                    authorizationVM.regEmail = emailText
                                    authorizationVM.regPassword = passwordText
                                    authorizationVM.register()
                                }else{
                                    passwordsDontMatch = true
                                }
                            }
                        }label: {
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .padding(.vertical, 12)
                                Text("Register")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("LoginButtonText"))
                                    .padding(.vertical, 12)
                                    .background(.clear)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .padding(.top, 10)
                        }
                    }
                }else if authorizationVM.registerStatus == .loading{
                    ProgressView()
                        .padding()
                }else if authorizationVM.registerStatus  == .success{
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                        .padding()
                }else if authorizationVM.registerStatus == .failure{
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                        .padding()
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
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $isEmailInvalid){
            Alert(title: Text("Invalid Email"), message: Text("Please enter a valid email address."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $passwordsDontMatch){
            Alert(title: Text("Passwords do not match"), message: Text("Your passwords should match"), dismissButton: .default(Text("OK")))
        }
        
    }
}

extension RegistrationView{
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
            isEmailInvalid = true 
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Simple email validation using regular expression
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

