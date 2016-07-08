//
//  FirebaseHelper.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import Firebase
import FirebaseAuth
import UIKit
class FirebaseHelper {
    
    static let storageRef = FIRStorage.storage().referenceForURL("gs://winit-2941c.appspot.com")
    
    static let rootRef = FIRDatabase.database().reference()
    
    static var userID = (FIRAuth.auth()?.currentUser?.uid)!
    
    static func fillpostList(rangeMin: Int, rangeMax: Int, callback: ([Post]) -> Void){
		
		let postDownloadCallback = { (snapshot: FIRDataSnapshot) -> Void in
			// Get the post list of all posts
			var posts: [Post] = []
			for postDict in snapshot.children{
				let post = Post(snapshot: postDict as! FIRDataSnapshot)
				FirebaseHelper.setIfLiked(post)
				//post.liked=true
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
        if post.picture == nil{
            post.picture = UIImage(named: "NoImage")
        }
        
        let newPostRef = rootRef.child("posts").childByAutoId()
        post.key = newPostRef.key
        newPostRef.setValue(post.toDict())
        print("post and than user \(post.key)   \(post.user)")
        FirebaseHelper.uploadImage(UIImageJPEGRepresentation(post.picture!,0.5)!, postID: post.key, uploadDone: FirebaseHelper.printSth)
    }
    static func printSth(t: FIRStorageTaskSnapshot){
        print("UPLOADED")
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
	
	static func getLikedPosts(whenDone: ([Post]) -> Void) {
		
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
	
	static func setIfLiked(post: Post) {
		
		let userKey = (FIRAuth.auth()?.currentUser?.uid)!
		let postKey = post.key
		
		func postKeyDownloadCallback(snapshot: FIRDataSnapshot) {
			
			if snapshot.exists() {
				
				post.liked = true
				print("post like downloaded")
			}
		}
		
		//func
		
		let postKeyQuery = rootRef.child("likesByUser/\(userKey)/\(postKey)")
		
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
    
    //Storage Stuff
    static func downloadImage(post: Post, callback: (UIImage) -> Void){
        let storageRef = FirebaseHelper.storageRef
        storageRef.child("PostImages/\(post.key)")
        storageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                let errorImage = UIImage(named: "NoImage")
                print("error during download: \(error)")
                callback(errorImage!)
            } else {
                let imageFile = UIImage(data: data!)
                callback(imageFile!)
            }
        }
    }
    
    static func uploadImage(image: NSData, postID: String, uploadDone: (FIRStorageTaskSnapshot) -> Void){

        let storageRef = FirebaseHelper.storageRef
        let path = "PostImages/\(postID).jpg"
        let uploadTask = storageRef.child(path).putData(image, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("error")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
//                let downloadURL = metadata!.downloadURL
            }
        }
        uploadTask.observeStatus(.Resume,handler: uploadDone)

//        //the returnvalue should be saved inside of a upoad Task Variable
//        //there shoulb also be a handler which makes sure that files are uploaded before other people could try download
    }
}
