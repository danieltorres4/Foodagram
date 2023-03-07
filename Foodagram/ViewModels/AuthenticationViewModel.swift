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
    @Published var linkedAccounts: [LinkAccounts] = []
    @Published var showAlert: Bool = false
    @Published var isLinkedAccount: Bool = false
    
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
    
    func logout() {
        do {
            try authenticationRepository.logout()
            self.user = nil
        } catch {
            print("Error while trying to logout...")
        }
    }
    
    /// This method will be called from the LoginEmailView
    func login(email: String, password: String) {
        /// [weak self] to avoid retain cycles
        authenticationRepository.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func loginWithFacebook() {
        /// [weak self] to avoid retain cycles
        authenticationRepository.loginWithFacebook() { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func getCurrentProvider() {
        linkedAccounts = authenticationRepository.getCurrentProvider()
    }
    
    /// Helpers that will be used in the view to know if a button is active or not
    func isEmailAndPasswordLinked() -> Bool {
        linkedAccounts.contains(where: { $0.rawValue == "password" })
    }
    
    func isFacebookLinked() -> Bool {
        linkedAccounts.contains(where: { $0.rawValue == "facebook.com" })
    }
    
    func linkFacebook() {
        authenticationRepository.linkFacebook { [weak self] isSuccess in
            self?.isLinkedAccount = isSuccess
            self?.showAlert.toggle()
            self?.getCurrentProvider()
        }
    }
    
    func linkEmailAndPassword(email: String, password: String) {
        authenticationRepository.linkEmailAndPassword(email: email, password: password) { [weak self] isSuccess in
            self?.isLinkedAccount = isSuccess
            self?.showAlert.toggle()
            self?.getCurrentProvider()
        }
    }
}
