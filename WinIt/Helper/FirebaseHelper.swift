//
//  FirebaseHelper.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import Firebase
import FirebaseAuth
class FirebaseHelper {
    
    static let rootRef = FIRDatabase.database().reference()
	
    static func fillpostList(rangeMin: Int, rangeMax: Int, callback: ([Post]) -> Void){
		
		func postDownloadCallback(snapshot: FIRDataSnapshot)
		{
			// Get the post list of all posts
			var posts: [Post] = []
			for postDict in snapshot.children{
				let post = Post(snapshot: postDict as! FIRDataSnapshot)
				posts.append(post)
			}
			//refreshing the tableView
			callback(posts)
		}
		
        let postQuery = rootRef.child("posts")
        print("filll post list")
        postQuery.queryLimitedToLast(UInt(rangeMax))
        print("aaa")
        postQuery.queryOrderedByChild("time")
        
        postQuery.observeSingleEventOfType(.Value, withBlock: postDownloadCallback) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func addPost(post:Post){
        print("try to add")
        print(post.toDict())
        
        rootRef.child("posts").childByAutoId().setValue(post.toDict())
    }
    
    static func createAccount(username: String, coins: Int){
        if let user = FIRAuth.auth()?.currentUser{
            let userDict = ["coins":coins,
                            "username": username]
            rootRef.child("users").child(user.uid).setValue(userDict)
        }
        
    }
}
