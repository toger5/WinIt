//
//  File.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase

class LikesViewController: UIViewController {
    // MARK: - Properties
    var likedPosts: [Post] = []
    var selectedPost:Post? = nil
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycles
    override func viewDidLoad(){
        super.viewDidLoad()
        prepareTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        FirebaseHelper.getLikedPosts(likesLoaded)
        tableView.reloadData()
    }
    
    // MARK: - Preparations
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func unwindToYourLikes(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! GameViewController
        dvc.post = selectedPost
    }
    
    // MARK: - Helper Methods
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
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension LikesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("likedPostCell") as! LikedPostCell
        let post = likedPosts[indexPath.row]
        
        guard post.isPlaceHolderImage() || post.image == nil else {
            cell.populate(post)
            return cell
        }
        
        FirebaseHelper.downloadImage(post) { (image) in
            post.image = image
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        cell.populate(post)
        return cell
    }
}

// MARK: - Table View Delegate
extension LikesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let clickedPost: Post = likedPosts[indexPath.row]
        switch clickedPost.getState(){
        case EventStatus.Waiting:

            let animation = CustomAnimation(view: cell!, delay: 0, direction: .Left, repetitions: 3, maxRotation: 0, maxPosition: 20, duration: 0.1)
            animation.shakeAnimation()
        
        case EventStatus.Running:
            selectedPost = clickedPost
            self.performSegueWithIdentifier("toGame", sender: self)
        //will be needed as soon as the View Controller for the EventOverview is created
//        case EventStatus.Complete:
//            selectedPost = clickedPost
//            self.performSegueWithIdentifier("toEventOverview", sender: self)
        default:
            break
        }
    }
}