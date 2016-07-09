//
//  LikedPostCell.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

//
//  LikedPostCell.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class LikedPostCell: UITableViewCell{




    // MARK: - Properties
    var eventIsOnline = false
    var timeLeft: [Int] = []
    
    var clock: NSTimer? = nil
    var post: Post? = nil
    // MARK: - IBOutlets
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var countDownTimer: UILabel!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    // MARK: - Helper Methods
    func populate(post: Post){
        self.post = post
        postName.text = post.name
        postImage.image = post.picture
        posterName.text = post.user
        timeLeft = post.getHoursMinutesSecondsArray()
        handelCellDuringWait(timeLeft)
        print("timer created")
        if post.isCounting(){
            clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LikedPostCell.countdown), userInfo: nil, repeats: true)
        }else if post.isEventDone(){
            handleCellDuringGame(timeLeft)
        }
    }
    
    func countdown(timer: NSTimer){
        print("countdonw: \(timer)")
        if timeLeft[2] <= 0{
            if timeLeft[1] <= 0{
                if timeLeft[0] <= 0{
                    clock?.invalidate()
                    clock = nil
                    setTimerLabelToEventStart()
                    return
                }else{
                    timeLeft[0] -= 1
                    timeLeft[1] = 60
                    timeLeft[2] = 60
                }
            }else{
                timeLeft[1] -= 1
                timeLeft[2] = 60
            }
        }else{
            timeLeft[2] -= 1
        }
        if post!.isEventDone(){
            handleCellDuringGame(timeLeft)
        }else{
            handelCellDuringWait(timeLeft)
        }
    }
    
    func handelCellDuringWait(time: [Int]){
        countDownTimer.text = getStringBasedOnArray(time)
    }
    func getStringBasedOnArray(time: [Int]) -> String{return "\(abs(timeLeft[0])):\(abs(timeLeft[1])):\(abs(timeLeft[2]))"}
    
    
    func setTimerLabelToEventStart(){
        eventIsOnline = true
        countDownTimer.text = "Started!"
    }
    
    override func prepareForReuse() {
        clock?.invalidate()
    }
    
    func handleCellDuringGame(time: [Int]){
        countDownTimer.text = "Event Is Running\n \(getStringBasedOnArray(time))"
        
    }
}
