//
//  ProfileView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @State var expandVerificationWithEmailForm: Bool = false
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    
    var body: some View {
        Form {
            Section {
                Text("Username")
                Text("Email: \(authenticationViewModel.user?.email ?? "No User Logged Yet")")
            } header: {
                Label("User Info", systemImage: "person.crop.square.filled.and.at.rectangle")
            }
            
            Section {
                Button(action: {
                    expandVerificationWithEmailForm.toggle()
                }, label: {
                    Label("Link email and password", systemImage: "envelope.fill")
                })
                .disabled(authenticationViewModel.isEmailAndPasswordLinked())
                
                if expandVerificationWithEmailForm {
                    Group {
                        Text("Link your account with an email and password")
                            .tint(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        
                        TextField("Email", text: $textFieldEmail)
                        TextField("Password", text: $textFieldPassword)
                        
                        Button("Done") {
                            authenticationViewModel.linkEmailAndPassword(email: textFieldEmail, password: textFieldPassword)
                        }
                        .padding(.top, 18)
                        .buttonStyle(.bordered)
                        .tint(.purple)
                        
                        if let messageError = authenticationViewModel.messageError {
                            Text(messageError)
                                .bold()
                                .font(.body)
                                .foregroundColor(.red)
                                .padding(.top, 20)
                        }
                    }
                }
                
                Button(action: {
                    authenticationViewModel.linkFacebook()
                }, label: {
                    Label("Link Facebook", systemImage: "f.cursive")
                })
                .disabled(authenticationViewModel.isFacebookLinked())
            } header: {
                Label("Link other accounts to your session", systemImage: "link")
            }
        }
        .task {
            authenticationViewModel.getCurrentProvider()
        }
        .alert(authenticationViewModel.isLinkedAccount ? "Your account has been linked ✅" : "Error while linking your account ❌", isPresented: $authenticationViewModel.showAlert) {
            Button("Done") {
                if authenticationViewModel.isLinkedAccount {
                    expandVerificationWithEmailForm = false
                }
            }
        } message: {
            Text(authenticationViewModel.isLinkedAccount ? "Succesfully linked account" : "Failure")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(authenticationViewModel: AuthenticationViewModel())
    }
}
