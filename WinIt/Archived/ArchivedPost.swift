//
//  ArchivedPost.swift
//  WinIt
//
//  Created by Timo on 11/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase

class ArchivedPost: Post{
    var participatedUsers: [String: (String,Int)] // dictionary with Keys and (names,Points)
    var winner: (String, String)
    var amountOfLikes: Int

    override init(snapshot: FIRDataSnapshot) {
        self.participatedUsers = snapshot.value!["users"] as? [String: String] ?? ["nuUser": "test"]
        self.winner = snapshot.value!["winner"]
        self.amountOFLikes = snapshot.value!["amountOfLikes"]
        super.init(snapshot: snapshot)
    }
    
    init(post: Post, participatedUsers: [String: String], winner: (String, String)){
        self.participatedUsers = participatedUsers
        self.winner = winner
        super.init(post: post)
    }
    
    
    
}
