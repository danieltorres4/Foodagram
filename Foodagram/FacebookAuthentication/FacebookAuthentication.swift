//
//  FacebookAuthentication.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import Foundation
import FacebookLogin

/// Facebook login logic
final class FacebookAuthentication {
    let loginManager = LoginManager()
    
    func loginFacebook(completionBlock: @escaping (Result<String, Error>) -> Void) {
        loginManager.logIn(permissions: ["email"], from: nil) { loginManagerLoginResult, error in
            if let error = error {
                print("An error has been ocurred while login with Facebook: \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            
            let token = loginManagerLoginResult?.token?.tokenString
            completionBlock(.success(token ?? "Empty Token"))
        }
    }
    
    /// This method will returned the user's access token if there is a session active
    func getAccessToken() -> String? {
        AccessToken.current?.tokenString
    }
}
