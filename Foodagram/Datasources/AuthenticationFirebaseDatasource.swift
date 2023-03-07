//
//  AuthenticationFirebaseDatasource.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import Foundation
import FirebaseAuth

struct User {
    let email: String
}

/// This class contains the logic to register with email and password
///  It will have a createNewUser method that receives an email, password and a completion block to indicate if an error has ocurred. If an error ocurred, an error will be returned. Otherwise, a user will be returned.
final class AuthenticationFirebaseDatasource {
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
}
