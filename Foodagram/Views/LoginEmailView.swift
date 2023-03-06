//
//  LoginEmailView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import SwiftUI

struct LoginEmailView: View {
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    
    var body: some View {
        VStack {
            DismissView()
                .padding(.top, 8)
            
            Group {
                Text("Foodagram 🧁")
            }
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .bold()
            .tint(.primary)
            
            Group {
                Text("Login")
                    .tint(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                
                TextField("Email", text: $textFieldEmail)
                TextField("Password", text: $textFieldPassword)
                
                Button("Login") {
                    print("Login")
                }
                .padding(.top, 18)
                .buttonStyle(.bordered)
                .tint(.purple)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 64)
            Spacer()
        }
    }
}

struct LoginEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmailView()
    }
}
