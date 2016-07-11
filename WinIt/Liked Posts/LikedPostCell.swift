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

    var clock: CountDownLabelHelper? = nil
    var post: Post? = nil
    // MARK: - IBOutlets
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var countDownTimer: UITextView!
    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    // MARK: - Helper Methods
    func populate(post: Post){
        self.post = post
        postName.text = post.name
        postImage.image = post.image
        posterName.text = post.user
        
        handleCellStyleAndDescription()
        
        if post.getState().rawValue <= 1 /*  this means it is Waitng or Running */ {
            clock = CountDownLabelHelper(timeInSeconds: post.getTimeLeftInSeconds(), countDownCallback: { () in
                self.handleCellStyleAndDescription()
            })
        }
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
        countDownTimer.text = clock?.getTimeString()
    }
    func handleCellDuringComplete(){
        countDownTimer.text = "Completed \n Winner: Jake"
    }
    func handleCellDuringGame(){
        countDownTimer.text = "Event Is Running\n \(clock?.getTimeString())"
    }

    override func prepareForReuse() {
        clock?.stop()
    }
    
    
}
