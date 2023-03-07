//
//  PostView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        List {
            ForEach(postViewModel.posts) { post in
                VStack {
                    Text(post.title)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 8)
                    Text("From: \(post.place)")
                        .foregroundColor(.gray)
                        .italic()
                        .font(.caption)
                        .padding(.bottom, 8)
                    Text(post.description)
                        .font(.body)
            
                    HStack {
                        Spacer()
                        if post.isFavorited {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .foregroundColor(.purple)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
        }
        .task {
            postViewModel.getAllPosts()
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(postViewModel: PostViewModel())
    }
}
