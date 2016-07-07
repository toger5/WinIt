//
//  File.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase

class yourLikesViewController: UIViewController {
    var likedPosts: [Post] = []
    
    @IBOutlet weak var tableVeiw: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
        FirebaseHelper.getLikes(likesLoaded)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func likesLoaded(posts: [Post]){
        likedPosts = posts
        tableVeiw.reloadData()
    }
}

extension yourLikesViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("likedPostCell") as LikedPostCell
        cell.populate(likedPosts[indexPath.row])
        return cell
    }
}