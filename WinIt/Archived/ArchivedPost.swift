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
    var participatedUsers: [String: String] // dictionary with Keys and names
    override init(snapshot: FIRDataSnapshot) {
        self.participatedUsers = snapshot.value!["users"] as? [String: String] ?? ["nuUser": "test"]
        super.init(snapshot: snapshot)
        
    }
    
//    init(post: Post,participatingUsers: [String: String], winner: (String, String)){
//        super.init(post)
//    }
}
