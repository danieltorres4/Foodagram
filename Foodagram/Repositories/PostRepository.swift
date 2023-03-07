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
}
