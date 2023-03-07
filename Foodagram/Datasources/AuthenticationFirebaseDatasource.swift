//
//  AuthenticationFirebaseDatasource.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import Foundation
import FirebaseAuth

/// This class contains the logic to register with email and password
///  It will have a createNewUser method that receives an email, password and a completion block to indicate if an error has ocurred. If an error ocurred, an error will be returned. Otherwise, a user will be returned.
final class AuthenticationFirebaseDatasource {
    private let facebookAuthentication = FacebookAuthentication()
    
    func createNewUser(email: String, password: String, completionBlock: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print("An error has been ocurred while creating a new user: \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            
            let email = authDataResult?.user.email ?? "No email"
            completionBlock(.success(.init(email: email)))
        }
    }
    
    /// Extracting the current session in case there is one
    func getCurrentUser() -> User? {
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }
        
        return .init(email: email)
    }
    
    /// This method will allow the user exit his session
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    /// This method will allow the user login his session
    func login(email: String, password: String, completionBlock: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print("An error has been ocurred while login the user: \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            
            let email = authDataResult?.user.email ?? "No email"
            completionBlock(.success(.init(email: email)))
        }
    }
    
    /// Facebook login
    func loginWithFacebook(completionBlock: @escaping (Result<User, Error>) -> Void) {
        facebookAuthentication.loginFacebook { result in
            switch result {
            case .success(let accessToken):
                //Creating facebook credential
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                Auth.auth().signIn(with: credential) { authDataResult, error in
                    if let error = error {
                        print("Error while creating a new user with Facebook: \(error.localizedDescription)")
                        completionBlock(.failure(error))
                        return
                    }
                    
                    let email = authDataResult?.user.email ?? "No email"
                    completionBlock(.success(.init(email: email)))
                }
                
            case .failure(let error):
                print("Error while signing with Facebook: \(error.localizedDescription)")
                completionBlock(.failure(error))
            }
        }
    }
    
    /// This method will return an array with all the linked providers with the email
    func getCurrentProvider() -> [LinkAccounts] {
        /// Trying to get the current user in case there is a session active
        guard let currentUser = Auth.auth().currentUser else { return [] }
        
        let linkedAccounts = currentUser.providerData.map { userInfo in
            LinkAccounts(rawValue: userInfo.providerID)
        }.compactMap { $0 }
        
        return linkedAccounts
    }
    
    func linkFacebook(completionBlock: @escaping (Bool) -> Void) {
        facebookAuthentication.loginFacebook { result in
            switch result {
            case .success(let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
                Auth.auth().currentUser?.link(with: credential, completion: { authDataResult, error in
                    if let error = error {
                        print("An error has been ocurred while linking Facebook: \(error.localizedDescription)")
                        completionBlock(false)
                        return
                    }
                    
                    /// Happy path
                    let email = authDataResult?.user.email ?? "No email"
                    completionBlock(true)
                })
            case .failure(let error):
                print("An error has been ocurred while linking Facebook: \(error.localizedDescription)")
                completionBlock(false)
            }
        }
    }
    
    /// This method will return a credential that can de used to link an account with another provider
    func getCurrentCredential() -> AuthCredential? {
        guard let providerID = getCurrentProvider().last else {
            return nil
        }
        
        switch providerID {
        case .facebook:
            guard let accessToken = facebookAuthentication.getAccessToken() else {
                return nil
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            
            return credential
            
        case .emailAndPassword, .unknown:
            return nil
        }
    }
    
    func linkEmailAndPassword(email: String, password: String, completionBlock: @escaping (Bool) -> Void) {
        /// Trying to get a provider credential
        guard let credential = getCurrentCredential() else {
            print("Error while creating credential...")
            completionBlock(false)
            return
        }
        
        /// With the credential, the next step is reauthenticate the user
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { authDataResult, error in
            if let error = error {
                print("Error while linking email and password: \(error.localizedDescription)")
                completionBlock(false)
                return
            }
            
            /// Email and password credential, then link the current user with email and password
            let emailAndPasswordCredential = EmailAuthProvider.credential(withEmail: email, password: password)
            Auth.auth().currentUser?.link(with: emailAndPasswordCredential, completion: { authDataResult, error in
                if let error = error {
                    print("An error has been ocurred while linking email and password: \(error.localizedDescription)")
                    completionBlock(false)
                    return
                }
                
                /// Happy path
                let email = authDataResult?.user.email ?? "No email"
                completionBlock(true)
            })
        })
    }
}
