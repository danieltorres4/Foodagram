//
//  FoodagramApp.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}

@main
struct FoodagramApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            if let user = authenticationViewModel.user {
                /// The login has been successfully
                HomeView(authenticationViewModel: authenticationViewModel)
            } else {
                /// There is no user logged
                AuthenticationView(authenticationViewModel: authenticationViewModel)
            }
        }
    }
}
