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
		
		
		
		let postDownloadCallback = { (snapshot: FIRDataSnapshot) -> Void in
			// Get the post list of all posts
			var posts: [Post] = []
			for postDict in snapshot.children{
				let post = Post(snapshot: postDict as! FIRDataSnapshot)
				posts.append(post)
			}
			//refreshing the tableView
			callback(posts)
		}

		
		//func postDownloadCallback
		
        let postQuery = rootRef.child("posts")
        print("fill post list")
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
	
	static func addLike(post: Post) {
		
		let userKey = (FIRAuth.auth()?.currentUser?.uid)!
		let postKey = post.key
		
		rootRef.child("likesByPost").child(postKey).updateChildValues([userKey: true])
		rootRef.child("likesByUser").child(userKey).updateChildValues([postKey: true])
	}
	
	static func removeLike(post: Post) {
		
		let userKey = (FIRAuth.auth()?.currentUser?.uid)!
		let postKey = post.key
		
		rootRef.child("likesByPost/\(postKey)/\(userKey)").removeValue()
		rootRef.child("likesByPost/\(userKey)/\(postKey)").removeValue()
	}
	
	static func getLikes(whenDone: ([Post]) -> Void) {
		
		let userKey = (FIRAuth.auth()?.currentUser?.uid)!
		
		var likesLeft: UInt = 0
		var posts: [Post] = []
		
		func postKeyDownloadCallback(snapshot: FIRDataSnapshot) {
			
			func postDownloadedCallback(snapshot: FIRDataSnapshot) {
				let post = Post(snapshot: snapshot)
				posts.append(post)
				
				likesLeft -= 1
				
				if likesLeft == 0 {
					whenDone(posts)
				}
			}
			
			likesLeft=snapshot.childrenCount
			
			for postKeyDict in snapshot.children{
				let postKey = (postKeyDict as! FIRDataSnapshot).key
				
				let postQuery = rootRef.child("posts/\(postKey)")
				
				postQuery.observeSingleEventOfType(.Value, withBlock: postDownloadedCallback) { (error) in
					print(error.localizedDescription)
				}
			}
		}
		
		//func
		
		let postKeyQuery = rootRef.child("likesByUser/\(userKey)")
		
		postKeyQuery.observeSingleEventOfType(.Value, withBlock: postKeyDownloadCallback) { (error) in
			print(error.localizedDescription)
		}
	}
	
    static func createAccount(username: String, coins: Int){
        if let user = FIRAuth.auth()?.currentUser{
            let userDict = ["coins":coins,
                            "username": username]
            rootRef.child("users").child(user.uid).setValue(userDict)
        }
        
    }
    

}
