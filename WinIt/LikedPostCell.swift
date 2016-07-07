//
//  LikedPostCell.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class LikedPostCell: UITableViewCell{
    
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var countDownTimer: UILabel!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    var eventIsOnline = false
    var timeLeft: [Int] = []
    
    var clock: NSTimer? = nil
    
    func populate(post: Post){
        postName.text = post.name
        postImage.image = post.picture
        posterName.text = post.user
        timeLeft = post.getHoursMinutesSecondsArray()
        setTimerBasedOnArray(timeLeft)
        
        clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
    }
    
    func countdown(){
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
        setTimerBasedOnArray(timeLeft)
    }
    
    func setTimerBasedOnArray(time: [Int]){
        countDownTimer.text = "\(timeLeft[0]):\(timeLeft[1]):\(timeLeft[2])"
    }
    
    func setTimerLabelToEventStart(){
        eventIsOnline = true
        countDownTimer.text = "Event Started!"
    }
    
}
