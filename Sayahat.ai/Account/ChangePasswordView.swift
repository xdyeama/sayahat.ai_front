//
//  ChangePasswordView.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 29.07.2023.
//

import SwiftUI
import Moya

struct ChangePasswordView: View {
    @ObservedObject var authorizationVM: AuthorizationViewModel
    @State var newPassword: String = ""
    @State var isPasswordChangeSuccess: Bool = false
    @State var isPasswordChangeFail: Bool = false
    var body: some View {
        VStack{
            VStack(spacing: 50){
                Text("Change password form")
                    .font(.title.bold())
                
                VStack(alignment: .center, spacing: 10){
                    VStack(alignment: .leading){
                        Text("New password")
                            .font(.subheadline.bold())
                        CustomTextField(placeholder: "Enter the new password", value: $newPassword, isPassword: true)
                    }
                    Button{
                        changePassword()
                    }label:{

                            Text("Change password")
                            .font(.subheadline.bold())
                                .frame(maxWidth: 140, maxHeight: 45)
                                .backgroundStyle(.clear)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                    }
                    .buttonStyle(.plain)

                }
                Spacer()
            }
            .frame(maxHeight: 300)
            .padding()
         Spacer()
        }
        .alert(isPresented: $isPasswordChangeSuccess){
            Alert(title: Text("Successfully changed password"), message: Text("You have successfully changed your password. Your new password is \(newPassword). Use it next time loginning in."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $isPasswordChangeFail){
            Alert(title: Text("Failed to change password."), message: Text("Failed to change password. Please try again later"), dismissButton: .default(Text("OK")))
        }
    }
}

extension ChangePasswordView{
    func CustomTextField(placeholder: String, value: Binding<String>, isPassword: Bool = false) -> some View{
        Group {
            if isPassword{
                SecureField(placeholder, text: value)
            }else{
                TextField(placeholder, text: value)
            }
            
        }
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .foregroundColor(Color.white)
        .background(Color("TextField"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
    }
    
    private func changePassword(){
        let provider = MoyaProvider<AuthorizationService>()
        
        provider.request(.changePassword(token: AppDataAPI.token, newPassword: newPassword)){result in
            switch result{
            case .success(let response):
                if response.statusCode == 200{
                    do{
                        isPasswordChangeSuccess = true
                        newPassword = ""
                    }catch{
                        print("Error decoding JSON: \(error.localizedDescription)")
                        isPasswordChangeFail = true
                        newPassword = ""
                    }
                }else{
                    print("Password change failed. Response: \(response)")
                    isPasswordChangeFail = true
                    newPassword = ""
                }
            case .failure(let error):
                print("Password change failed. Error: \(error.localizedDescription)")
                isPasswordChangeFail = true
                newPassword = ""
            }
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(authorizationVM: AuthorizationViewModel())
    }
}
