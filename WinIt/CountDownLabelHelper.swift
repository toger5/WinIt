//
//  timerLabelHelper.swift
//  WinIt
//
//  Created by Timo on 09/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

typealias CountDownFunc = () -> Void

class CountDownLabelHelper: NSObject{
    
    
    var time: Int = 0
    var countDownCallback: CountDownFunc? = nil
    
    
    var countDown: NSTimer?
    
    init(timeInSeconds: Double, countDownCallback: CountDownFunc){
        super.init()
        time = Int(timeInSeconds)
        self.countDownCallback = countDownCallback
        countDown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CountDownLabelHelper.countdown), userInfo: nil, repeats: true)
    }
    
    init(timeArray: [Int], countDownCallback: CountDownFunc){
        super.init()
        if timeArray.count >= 3{
            time = (timeArray[0] * 60 * 60) + (timeArray[1] * 60) + (timeArray[2])
            if timeArray.count == 4{
                time = time + (timeArray[3] * 60 * 60 * 24)
            }
        }
        countDown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CountDownLabelHelper.countdown), userInfo: nil, repeats: true)
    }
    
    override init(){
        super.init()
        time = 0
        countDown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CountDownLabelHelper.countdown), userInfo: nil, repeats: true)
    }
    
    func countdown(){
        time -= 1
        countDownCallback!()
        
    }
    
    func getTimeString() -> String{
        return "\(toTwoFieldString(hours())):\(toTwoFieldString(minutes())):\(toTwoFieldString(seconds()))"
    }
    
    func stop() {
        countDown?.invalidate()
    }
    
    func toTwoFieldString(time: Int) -> String{
        if abs(time) < 10{
            return "0\(abs(time))"
        }else{
            return "\(abs(time))"
        }
    }
    
    //MARK: functions to get the time
    func days() -> Int{
        return time / (60 * 60 * 24)
    }
    func hours() -> Int{
        return (time / (60 * 60)) % (60 * 60 * 24)
    }
    func minutes() -> Int{
        return (time / (60)) % (60 * 60)
    }
    func seconds() -> Int{
        return time % 60
    }
    func wholeTimeInSeconds() -> Int{
        return time
    }
    
}

