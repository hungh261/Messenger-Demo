//
//  LoginView.swift
//  Messenger
//
//  Created by Zeno on 09/12/2020.
//

import SwiftUI

struct LoginView: View {
    @State
    private var isLogin = false
    
    @State
    private var email = ""
    @State
    private var password = "123456"
    @State
    private var nickName = ""
    
    @EnvironmentObject
    var loginController: LoginController
        
    var body: some View {
        NavigationView {
            VStack {
                if !loginController.isAuthenticated {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textCase(.lowercase)
                        .padding()
                        .multilineTextAlignment(.center)
                    TextField("Nickname", text: $nickName)
                        .padding()
                        .multilineTextAlignment(.center)
                    SecureField("Password", text: $password)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    NavigationLink(destination: ConversationView().environmentObject(ConversationController())) {
                        Text("Conversations")
                    }.padding()
                }
                Button(action: {
                    if loginController.isAuthenticated {
                        self.executeLogout()
                    } else {
                        self.executeLogin()
                    }
                }) {
                    if loginController.isAuthenticated {
                        Text("Logout")
                    } else {
                        Text("Login")
                    }
                    
                }.padding()
            }.navigationBarTitle("Test", displayMode: .inline)
        }
    }
    
    func executeLogin() {
        loginController.login(email: email, password: password, nickName: nickName)
    }
    
    func executeLogout() {
        loginController.logout()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
