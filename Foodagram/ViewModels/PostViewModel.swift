//
//  PostViewModel.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import Foundation

final class PostViewModel: ObservableObject {
    private let postRepository: PostRepository
    @Published var posts: [PostModel] = []
    @Published var messageError: String?
    @Published var showAlert: Bool = false
    
    init(postRepository: PostRepository = PostRepository()) {
        self.postRepository = postRepository
    }
    
    func getAllPosts() {
        postRepository.getAllPosts { [weak self] result in
            switch result {
            case .success(let postModels):
                self?.posts = postModels
                
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func createPost(title: String, place: String, description: String, isFavorited: Bool) {
        postRepository.createPost(title: title, place: place, description: description, isFavorited: isFavorited) { [weak self] result in
            switch result {
            case .success(let post):
                print("Successful task... Created a new post")
            case .failure(let error):
                self?.messageError = error.localizedDescription
            }
        }
    }
    
    func updateIsFavoritedProperty(post: PostModel) {
        let updatedPost = PostModel(id: post.id, title: post.title, place: post.place, description: post.description, isFavorited: post.isFavorited ? false : true)
        postRepository.updatePost(post: updatedPost)
    }
    
    func deletePost(post: PostModel) {
        postRepository.deletePost(post: post)
    }
}
