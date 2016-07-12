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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        FirebaseHelper.getLikedPosts(likesLoaded)
        tableView.reloadData()
    } 
    
    // MARK: - Segues
    @IBAction func unwindToYourLikes(segue: UIStoryboardSegue) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! GameViewController
        dvc.post = selectedPost
    }
    
    // MARK: - Helper Methods
    func likesLoaded(posts: [Post]) {
        
        var newPosts: [Post] = []
        
        for i in posts {
            var doesExist = false
            for p in self.likedPosts{
                if i.key == p.key {
                    doesExist = true
                    newPosts.append(p)
                }
            }
            
            if !doesExist{
                newPosts.append(i)
            }
        }
        likedPosts = newPosts
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension LikesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.LikedPostTableViewCell) as! LikedPostTableViewCell
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
        print("Cell: \(indexPath.row)")
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let clickedPost: Post = likedPosts[indexPath.row]
        
        switch clickedPost.getState() {
        case EventStatus.Waiting:
            print("Waiting")
            let animation = CustomAnimation(view: cell!, delay: 0, direction: .Left, repetitions: 3, maxRotation: 0, maxPosition: 20, duration: 0.1)
            animation.shakeAnimation()
        
        case EventStatus.Running:
            print("Running")
            selectedPost = clickedPost
            self.performSegueWithIdentifier("toGame", sender: self)
        //will be needed as soon as the View Controller for the EventOverview is created
        case EventStatus.Complete:
            print("Completed")
//            selectedPost = clickedPost
//            self.performSegueWithIdentifier("toEventOverview", sender: self)
        default:
            print("Cell in default state - Archived")
        }
    }
}