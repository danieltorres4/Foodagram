//
//  PostRepository.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import Foundation

final class PostRepository {
    private let postDatasource: PostDatasource
    
    init(postDatasource: PostDatasource = PostDatasource()) {
        self.postDatasource = postDatasource
    }
    
    func getAllPosts(completionBlock: @escaping (Result<[PostModel], Error>) -> Void) {
        postDatasource.getAllPosts(completionBlock: completionBlock)
    }
    
    func createPost(title: String, place: String, description: String, isFavorited: Bool, completionBlock: @escaping (Result<PostModel, Error>) -> Void) {
        //postDatasource.createPost(title: title, place: place, description: description, isFavorited: isFavorited, completionBlock: completionBlock)
        postDatasource.createPost(title: title, place: place, description: description, isFavorited: isFavorited) { [weak self] result in
            switch result {
            case .success(let postModel):
                self?.postDatasource.createNewPost(post: postModel, completionBlock: completionBlock)
                
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
    }
}
