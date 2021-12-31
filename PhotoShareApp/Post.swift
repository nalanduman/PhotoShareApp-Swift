//
//  Post.swift
//  PhotoShareApp
//
//  Created by Nalan Duman on 31.12.2021.
//

import Foundation

class Post {
    var email: String
    var comment: String
    var imageUrl: String
    
    init(email: String, comment: String, imageUrl: String) {
        self.email = email
        self.comment = comment
        self.imageUrl = imageUrl
    }
}
