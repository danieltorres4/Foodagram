//
//  PostView.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @State var postTitle: String = ""
    @State var postDescription: String = ""
    @State var postPlace: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Group {
                    TextField("Post's title", text: $postTitle)
                        .frame(height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.purple, lineWidth: 2))
                        .padding(.horizontal, 12)
                        .cornerRadius(3)
                    
                    TextField("Place", text: $postPlace)
                        .frame(height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.purple, lineWidth: 2))
                        .padding(.horizontal, 12)
                        .cornerRadius(3)
                    
                    TextEditor(text: $postDescription)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.purple, lineWidth: 2))
                        .padding(.horizontal, 12)
                        .cornerRadius(3)
                    
                    Button(action: {
                        postViewModel.createPost(title: postTitle, place: postPlace, description: postDescription, isFavorited: false)
                    }, label: {
                        Label("Create Post", systemImage: "doc.append")
                    })
                    .tint(.purple)
                    .controlSize(.regular)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    if postViewModel.messageError != nil {
                        Text(postViewModel.messageError!)
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
            
            
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
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(postViewModel: PostViewModel())
    }
}
