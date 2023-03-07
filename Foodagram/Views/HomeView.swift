//
//  HomeView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 06/03/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var postViewModel: PostViewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    Text("Welcome, \(authenticationViewModel.user?.email ?? "No User")")
                        .padding(.top, 32)
                    Spacer()
                    
                    PostView(postViewModel: postViewModel)
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                ProfileView(authenticationViewModel: authenticationViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "figure.wave")
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Foodagram 🧁")
            .toolbar {
                Button("Logout") {
                    authenticationViewModel.logout()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(authenticationViewModel: AuthenticationViewModel())
    }
}
