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
}
