//
//  MessengerApp.swift
//  Messenger
//
//  Created by Zeno on 11/25/20.
//

import SwiftUI
import MessengerFirestore
import MessengerInterface

@main
struct MessengerApp: App {
    var config: MessengerInterface.ConfigsType
    var loginController: LoginController
    init() {
        let configPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        MessengerFirestore.Configs.config(firebaseAppConfigPath: configPath)
        let fConfig = MessengerFirestore.Configs(authenticationService: nil, sourceModelCreator: nil)
        config = fConfig
        MessengerInterface.ConfigsManager.setup(config)
        loginController = LoginController(authenticationService: fConfig.authenticationService)
    }
    var body: some Scene {
        WindowGroup {
            LoginView().environmentObject(loginController)
        }
    }
}
