//
//  AuthenticationView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import SwiftUI

enum AuthenticationSheetView: String, Identifiable{
    case register
    case login
    
    var id: String {
        return rawValue
    }
}

struct AuthenticationView: View {
    @State private var authenticationSheetView: AuthenticationSheetView?
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Image("foodagram")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            
            VStack {
                Button {
                    authenticationSheetView = .login
                } label: {
                    Label("Login with email", systemImage: "envelope.fill")
                }
                .tint(.purple)
                
                Button {
                    authenticationViewModel.loginWithFacebook()
                } label: {
                    Label("Login with Facebook", systemImage: "f.cursive")
                }
                .tint(.purple)
            }
            .controlSize(.large)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .padding(.top, 60)
            Spacer()
            
            HStack {
                Button {
                    authenticationSheetView = .register
                } label: {
                    Text("Didn't have an account yet?")
                    Text("Register")
                        .underline()
                }
                .tint(.purple)
            }
        }
        .sheet(item: $authenticationSheetView) { sheet in
            switch sheet {
            case .register:
                RegisterEmailView(authenticationViewModel: authenticationViewModel)
            case .login:
                LoginEmailView(authenticationViewModel: authenticationViewModel)
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authenticationViewModel: AuthenticationViewModel())
    }
}
