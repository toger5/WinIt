//
//  GameViewController.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GameViewController: UIViewController{
    
    // MARK: - Properties
    var post: Post? = nil
    var points = 0
    var clock: CountDownLabelHelper? = nil
    var pathToGame: FIRDatabaseReference? = nil
    var labels: [UILabel] = []
    var names: [UILabel] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var livePointUpdate: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var name5: UILabel!
    
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePathToGame()
        prepareClock()
        setPointsIfAlreadyPlayed()
        prepareLabels()
        prepareNames()
        startOtherPlayersObserver()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startOtherPlayersObserver()
    }
    
    // MARK: - Preparations
    func preparePathToGame() {
        pathToGame = FirebaseHelper.rootRef.child("gameByPost/\(post!.key)")
    }
    
    func prepareClock() {
        clock = CountDownLabelHelper(timeInSeconds: (post?.getTimeLeftInSeconds())!, countDownCallback: clockTick)
    }
    
    func prepareLabels() {
        labels = [p1, p2, p3, p4, p5]
    }
    
    func prepareNames() {
        names = [name1, name2, name3, name4, name5]
    }
    
    // MARK: - IBActions
    @IBAction func buttonPressed(sender: AnyObject) {
        points -= 1
        updateDatabase()
        FirebaseHelper.getWinnerOfPost(post!) { (username, userKey) in
            self.livePointUpdate.text = username
        }
        //        livePointUpdate.text = String(-points)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        clock?.stop()
    }
    
    // MARK: - Helper Methods
    func updateDatabase() {
        let pathToGameThisUser = pathToGame!.child((FIRAuth.auth()?.currentUser?.uid)!)
        pathToGameThisUser.setValue(points)
    }
    
    func clockTick() {
        self.timerLabel.text = self.clock!.getTimeString()
        if self.clock?.wholeTimeInSeconds() <= 0 {
            eventStop()
        }
    }
    
    func eventStop() {
        clock?.stop()
        clickButton.enabled = false
    }
    
    func startOtherPlayersObserver() {
        pathToGame!.queryOrderedByValue().queryLimitedToFirst(5).observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            
            for (index, snap) in snapshot.children.enumerate() {
                
                let s = snap as! FIRDataSnapshot
                let points = s.value! as! Double
                
                self.labels[index].text = String(-points)
                
                let toUser = FirebaseHelper.rootRef.child("users/\(s.key)")
                
                toUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let n = (snapshot.value!["username"] ?? "could not find user name")!
                    self.names[index].text = "\(index + 1). \(n)"
                })
            }
        }
    }
    
    func setPointsIfAlreadyPlayed() {
        pathToGame!.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            guard snapshot.hasChild(FirebaseHelper.userID!) else { return }
            
            self.points = (snapshot.childSnapshotForPath(FirebaseHelper.userID!).value! as! Int) ?? 0
            self.livePointUpdate.text = String(-self.points)
        })
    }
}
