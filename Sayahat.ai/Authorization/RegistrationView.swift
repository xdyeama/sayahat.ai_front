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
    @ObservedObject var authorizationVM: AuthorizationViewModel
    @Binding var isLoggedIn: Bool
    @State var isEmailInvalid: Bool = false
    @State var passwordsDontMatch: Bool = false
    @State var fullName: String = ""
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State var passwordConfirm: String = ""
    @State var isRegistered: Bool = false
    var body: some View {
        VStack(spacing: 12){
            Text("SignUp")
                .font(.title.bold())
                .foregroundColor(Color.black)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Email")
                    .font(.callout.bold())
                    .foregroundColor(Color.black)
                CustomTextField(placeholder: "example@mail.com", value: $emailText)
                
                Text("Password")
                    .font(.callout.bold())
                    .foregroundColor(Color.black)
                CustomTextField(placeholder: "********", value: $passwordText, isPassword: true)
                
                Text("Confirm Password")
                    .font(.callout.bold())
                    .foregroundColor(Color.black)
                CustomTextField(placeholder: "********", value: $passwordConfirm, isPassword: true)
                
                HStack{
                    Text("Already a member? ")
                        .font(.subheadline)
                    NavigationLink(value: "Authorization"){
                        Text("Sign in")
                            .font(.subheadline)
                            .underline()
                            .foregroundColor(.blue)
                    }
                }
                if authorizationVM.registerStatus == .none{
                    NavigationLink(destination: AuthorizationView(authorizationVM: authorizationVM, isLoggedIn: $isLoggedIn)){
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
                            .padding(.top, 30)
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
        .disableAutocorrection(true)
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

