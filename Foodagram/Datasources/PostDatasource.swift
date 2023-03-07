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
}
