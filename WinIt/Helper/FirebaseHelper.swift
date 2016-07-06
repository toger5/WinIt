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
        
        rootRef.child("Posts").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get the post list of all posts
            
            var offerArray: [Post] = []
            for post in snapshot.children{

                let offer = Post(snapshot: post as! FIRDataSnapshot)
                offerArray.append(offer)

            }
            //refreshing the tableView
            callback(offerArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func addPost(post:Post){
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
