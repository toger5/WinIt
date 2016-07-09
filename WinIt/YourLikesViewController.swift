//
//  File.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase

class YourLikesViewController: UIViewController {
    // MARK: - Properties
    var likedPosts: [Post] = []
    var selectedPost:Post? = nil
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableVeiw: UITableView!
    
    // MARK: - View Lifecycles
    override func viewDidLoad(){
        super.viewDidLoad()
        tableVeiw.dataSource = self
        tableVeiw.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        FirebaseHelper.getLikedPosts(likesLoaded)
        tableVeiw.reloadData()
    }
    
    
    func likesLoaded(serverPostList: [Post]){
        var newPostArray: [Post] = []
        
        for o in serverPostList{
            var exist = false
            for p in self.likedPosts{
                if o.key == p.key{
                    exist = true
                    newPostArray.append(p)
                }
            }
            if !exist{
                newPostArray.append(o)
            }
        }
        likedPosts = newPostArray
        tableVeiw.reloadData()
    }
    @IBAction func unwindToYourLikes(segue: UIStoryboardSegue) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! GameViewController).post = selectedPost
    }
}


extension YourLikesViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likedPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("likedPostCell") as! LikedPostCell
        let post = likedPosts[indexPath.row]
        if post.picture == nil{
            FirebaseHelper.downloadImage(post) { (productImage) in
                //            print(productImage)
                //            cell.imageViewProduct.image = productImage
                post.picture = productImage
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        cell.populate(post)
        return cell
    }
}

extension YourLikesViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableVeiw.cellForRowAtIndexPath(indexPath)
        let clickedPost: Post = likedPosts[indexPath.row]
        if  !clickedPost.isCounting() {
            selectedPost = clickedPost
            self.performSegueWithIdentifier("toGame", sender: self)
        }else{
            let animation = CustomAnimation(view: cell!, delay: 0, direction: .Left, repetitions: 3, maxRotation: 0, maxPosition: 20, duration: 0.1)
            
            animation.shakeAnimation()
        }
    }
}