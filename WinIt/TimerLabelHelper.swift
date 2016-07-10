//
//  timerLabelHelper.swift
//  WinIt
//
//  Created by Timo on 09/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
class TimerLabelHelper{
    
    let clock = NSTimer.scheduledTimerWithTimeInterval(interval: 1.0,
                                                       target: self,
                                                       selector: #selector(TimerLabelHelper.countdown),
                                                       userInfo: nil,
                                                       repeats: true)
    var time: [Int] = []
    var countDownCallback: (timeArray: [Int]) -> Void
    
    
    init(timeInSeconds: Double, countDownCallback: () -> Void){
        self.countDownCallback = countDownCallback
        time = [Int(timeLeft / 60 / 60),Int((timeLeft%(60 * 60)) / 60),Int(timeLeft%60)]
    }
    init(timeArray: [Int]){
        time = timeArray
    }
    init(){
        time = [0,0,0]
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
        countDownCallback(time)
    }
    
    func getStringBasedOnArray(time: [Int]) -> String{
        return "\(abs(timeLeft[0])):\(abs(timeLeft[1])):\(abs(timeLeft[2]))"
    }
    
    func stop() {
        clock?.invalidate()
    }

}

