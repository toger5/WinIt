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
        postImage.image = post.image
        posterName.text = post.user
        timeLeft = post.getHoursMinutesSecondsArray()
        
        handleCellStyleAndDescription()
        
        if post.getState().rawValue <= 1 /*  this means it is Waitng or Running */ {

            clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LikedPostCell.countdown), userInfo: nil, repeats: true)
        }
    }
    
    func countdown(timer: NSTimer){
        
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
        handleCellStyleAndDescription()
    }
    
    func handleCellStyleAndDescription(){
        if let post = post{
            switch post.getState(){
            case EventStatus.Waiting:
                handelCellDuringWait()
            case EventStatus.Running:
                handleCellDuringGame()
            case EventStatus.Complete:
                handleCellDuringComplete()
            case EventStatus.Archived:
                break
            }
        }else{
            print("The requested post object is nil")
        }
    }
    
    func handelCellDuringWait(){
        countDownTimer.text = getStringBasedOnArray(timeLeft)
    }
    func handleCellDuringComplete(){
        countDownTimer.text = "Completed /n Winner: Jake"
    }
    func handleCellDuringGame(){
        countDownTimer.text = "Event Is Running\n \(getStringBasedOnArray(timeLeft))"
    }

    func getStringBasedOnArray(time: [Int]) -> String{
        return "\(abs(timeLeft[0])):\(abs(timeLeft[1])):\(abs(timeLeft[2]))"
    }
    
    func setTimerLabelToEventStart(){
        eventIsOnline = true
        countDownTimer.text = "Started!"
    }
    
    override func prepareForReuse() {
        clock?.invalidate()
    }
    
    
}
