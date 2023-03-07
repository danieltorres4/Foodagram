//
//  AuthenticationViewModel.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import Foundation

final class AuthenticationViewModel: ObservableObject {
    private let authenticationRepository: AuthenticationRepository
    
    /// Published properties to store a user and an error to keep control of what action will be done in the view
    @Published var user: User?
    @Published var messageError: String?
    
    init(authenticationRepository: AuthenticationRepository = AuthenticationRepository()) {
        self.authenticationRepository = authenticationRepository
        getCurrentUser()
    }
    
    /// This method will be called from the view. This method will receive 2 parameters from the textfields: email and password
    func createNewUser(email: String, password: String) {
        /// [weak self] to avoid retain cycles
        authenticationRepository.createNewUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    /// Extracting the current session in case there is one
    func getCurrentUser() {
        self.user = authenticationRepository.getCurrentUser()
    }
}
