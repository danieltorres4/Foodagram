//
//  PostModel.swift
//  Foodagram
//
//  Created by Iván Sánchez Torres on 07/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostModel: Decodable, Identifiable, Encodable {
    @DocumentID var id: String?
    let title: String
    let place: String
    let description: String
    let isFavorited: Bool
}
