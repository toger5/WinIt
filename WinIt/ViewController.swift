//
//  ViewController.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    let rootRef = FIRDatabase.database().reference()
    
    let dataListOfOffers = [Offer(),Offer(name: "computer", picture:nil, description:"anAlmostBrokenComputer", shippingCostIncluded: false)]
    @IBOutlet weak var tableView: MainTableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        rootRef.child("test0").setValue("baccccc")
        
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListOfOffers.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MainTableViewCell
        
        return populateCell(cell,offer: dataListOfOffers[indexPath.row])
    }
    
    func populateCell(cell: MainTableViewCell, offer:Offer) -> MainTableViewCell{
        
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



