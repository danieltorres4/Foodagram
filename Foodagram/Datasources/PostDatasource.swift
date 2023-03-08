//
//  PostDatasource.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Method to get the posts from the database and transform that info into PostModel properties
final class PostDatasource {
    private let database = Firestore.firestore()
    private let collection = "posts"
    
    func getAllPosts(completionBlock: @escaping (Result<[PostModel], Error>) -> Void) {
        database.collection(collection).addSnapshotListener { query, error in
            if let error = error {
                print("An error has been ocurred while getting the posts from the database: \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            
            /// Checking if there is a document
            guard let documents = query?.documents.compactMap({ $0 }) else {
                completionBlock(.success([])) /// an empty array if there is no documents
                return
            }
            
            /// In case there is a document at least, for each element found the info from the database is mapped into PostModel
            let posts = documents.map({ try? $0.data(as: PostModel.self)} ).compactMap({ $0 })
            
            completionBlock(.success(posts))
        }
    }
    
    func createPost(title: String, place: String, description: String, isFavorited: Bool, completionBlock: @escaping (Result<PostModel, Error>) -> Void) {
        let postModel = PostModel(title: title, place: place, description: description, isFavorited: isFavorited)
        
        completionBlock(.success(postModel))
    }
    
    func createNewPost(post: PostModel, completionBlock: @escaping (Result<PostModel, Error>) -> Void) {
        do {
            /// Trying to save the post into the database
            _ = try database.collection(collection).addDocument(from: post)
            completionBlock(.success(post))
        } catch {
            completionBlock(.failure(error))
        }
    }
    
    /// Method to update some post's properties
    func updatePost(post: PostModel) {
        /// Verifying if the post has an ID
        guard let documentID = post.id else {
            return
        }
        
        /// If the post has an ID...
        do {
            /// Specifying which document we want to update. If the happy path is fullfiled, the info will be updated
            _ = try database.collection(collection).document(documentID).setData(from: post)
        } catch {
            print("An error has been ocurred while updating a post...")
        }
    }
}
