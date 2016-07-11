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

        postQuery.queryLimitedToLast(UInt(rangeMax))
        
        postQuery.queryOrderedByChild("time")
        
        postQuery.observeSingleEventOfType(.Value, withBlock: postDownloadCallback) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func addPost(post:Post, callbackAfterUpload: (FIRStorageTaskSnapshot) -> Void){
        
        if post.image == nil{
            post.image = UIImage(named: "NoImage")
        }
        
        let newPostRef = rootRef.child("posts").childByAutoId()
        post.key = newPostRef.key
        newPostRef.setValue(post.toDict())
        
        FirebaseHelper.uploadImage(post.image!, postID: post.key, uploadDone: callbackAfterUpload)
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
        rootRef.child("likesByUser/\(userKey)/\(postKey)").removeValue()
    }
	
	static func getLikedPosts(whenDone: ([Post]) -> Void) {
		
		let userKey = (FIRAuth.auth()?.currentUser?.uid)!
		
		var likesLeft = 0
		var posts: [Post] = []
		
		func postKeyDownloadCallback(snapshot: FIRDataSnapshot) {
			
			func postDownloadedCallback(snapshot: FIRDataSnapshot) {
				let post = Post(snapshot: snapshot)
				posts.append(post)
				
				likesLeft -= 1
				
				if likesLeft <= 0 {
					
					print("liked posts: \(posts)")
					whenDone(posts)
				}
			}
			
			likesLeft=Int(snapshot.childrenCount)
			
			if likesLeft == 0 {
				
				whenDone(posts)
			
			} else {
			
				for postKeyDict in snapshot.children{
					let postKey = (postKeyDict as! FIRDataSnapshot).key
					
					let postQuery = rootRef.child("posts/\(postKey)")
					
					postQuery.observeSingleEventOfType(.Value, withBlock: postDownloadedCallback) { (error) in
						print(error.localizedDescription)
					}
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
    

//    static func getWinnerNameOfPost(post: Post){
//        let postQueryToWinningUserID = FirebaseHelper.rootRef.child("gameByPost/\(post.key)").queryOrderedByValue().queryLimitedToFirst(1)
//        postQueryToWinningUserID.observeSingleEventOfType(.Value) { (snapshot) in
//            let snap = snapshot[0] as! FIRDataSnapshot
//            FirebaseHelper.rootRef.child("users/\(snap)")
//            
//        }
//        
//        let toUser = FirebaseHelper.rootRef.child("users/\(s.key)")
//        toUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//            print(index)
//            //                    let n = (FIRAuth.id ?? "could not find user name")!
//            let n = (snapshot.value!["username"] ?? "could not find user name")!
//            (self.nameArray[index] as! UILabel).text = "\(index + 1). \(n)"
//        })
//    }
    

    static func removePost(post: Post){
		
		let postKey = post.key
		
		func postDownloadCallback(snapshot: FIRDataSnapshot) {
			
			for userData in snapshot.children{
				
				let userKey: String = userData.key
				
				rootRef.child("likesByUser/\(userKey)/\(postKey)").removeValue()
				rootRef.child("likesByPost/\(postKey)/\(userKey)").removeValue()
			}
		}
		
		let postKeyQuery = rootRef.child("likesByPost/\(postKey)")
		
		postKeyQuery.observeSingleEventOfType(.Value, withBlock: postDownloadCallback) { (error) in
			print(error.localizedDescription)
		}
		
		rootRef.child("posts/\(postKey)").removeValue()
    }
    
    //Storage Stuff
    static func downloadImage(post: Post, callback: (UIImage) -> Void){
        let storageRef = FirebaseHelper.storageRef
        let s = storageRef.child("PostImages/\(post.key).jpg")
        
        s.dataWithMaxSize(INT64_MAX) { (data, error) -> Void in
            if (error != nil) {
                let errorImage = UIImage(named: "NoImage")
                print("error during download: \(error?.localizedDescription)")
                callback(errorImage!)
            } else {
                let imageFile = UIImage(data: data!)
                print("downloadWorked \(imageFile)")
                callback(imageFile!)
            }
        }
    }
    

    static func uploadImage(image: UIImage, postID: String, uploadDone: (FIRStorageTaskSnapshot) -> Void){

        let storageRef = FirebaseHelper.storageRef
        let path = "PostImages/\(postID).jpg"
        let resizedImage = ImageHelper.resize(image, newWidth: 750)
        let smallerImage = UIImageJPEGRepresentation(resizedImage,0.3)!
        print("resized Image size: width\(resizedImage.size.width) height: \(resizedImage.size.height)")
        let uploadTask = storageRef.child(path).putData(smallerImage, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("error during upload \(error)")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
//                let downloadURL = metadata!.downloadURL
            }
        }
        uploadTask.observeStatus(.Success, handler: uploadDone)

//        //the returnvalue should be saved inside of a upoad Task Variable
//        //there shoulb also be a handler which makes sure that files are uploaded before other people could try download
    }
}
