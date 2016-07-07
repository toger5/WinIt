//
//  ViewController.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ViewController: UIViewController {
    let currentUser = FIRAuth.auth()!.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    var postList: [AnyObject] = []
    
//    let dataListOfOffers = [Offer(),Offer(name: "computer", picture:nil, description:"anAlmostBrokenComputer", shippingCostIncluded: false)]
    @IBOutlet weak var tableView: MainTableView!
    override func viewDidLoad() {
//        print(FIRUserInfo)
        print("curretn Logged In user: \(currentUser)")
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
//        print(FirebaseHelper.getOfferCount())
//        rootRef.child("test0").setValue("baccccc")
        super.viewDidAppear(animated)
        FirebaseHelper.addPost(Post(name: "haus", picture: nil, description: "meinHaus", key: "", eventTime: 1000, user:  currentUser!.uid))
        FirebaseHelper.fillpostList(0,rangeMax: 20,callback: { (offerArray) in
            self.postList = offerArray
            self.tableView.reloadData()
            print("test: \(self.postList)")
        })
    }
	
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		
	}

}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataListOfOffers.count
        print(postList.count)
        return postList.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MainTableViewCell
        
        let offer = postList[indexPath.row]
        
        return populateCell(cell, offer: offer as! Post)
    }
    
    func populateCell(cell: MainTableViewCell, offer:Post) -> MainTableViewCell{
        
        cell.nameLabel.text = offer.name
        cell.descriptionLabel.text = offer.description
        if let pic = offer.picture{
            cell.imageViewProduct.image = pic
        }else{
            cell.imageViewProduct.image = UIImage(named: "NoImage")
        }
        
        return cell
    }
}



