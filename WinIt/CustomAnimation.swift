









//
//  CoustomAnimation.swift
//  Makestagram
//
//  Created by Timo on 29/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

enum State{
    case First, Middle, Last
}
enum Direction: Int{
    case Left = 0, Right
}

class CustomAnimation{
    var state: State = .First
    var maxPosition: CGFloat!
    var maxRotation: CGFloat!
    var duration = 1.0
    var wait = 0.0
    var object: UIView!
    var repetitions: Int
    var direction: Direction = .Left
    
    var counter = 0
    
    init(obj: UIView, repetutionAmount: Int, maxRotation: CGFloat, maxPosition: CGFloat, duration: Double){
        self.maxPosition = maxPosition
        self.maxRotation = maxRotation
        repetitions = repetutionAmount
        self.duration = duration
        object = obj
    }
    
    func floatIn(toPosition: Int){
        UIView.animateWithDuration(duration, delay: wait, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            
            self.object.center.x = CGFloat(toPosition)
            
        }){(finished) in
            print("a")
        }
    }

    func shake(){
        var position = self.maxPosition
        var rotation = self.maxRotation
        
        switch self.state {
        case .First:
            position = self.maxPosition/2
            break
            
        case .Middle:
            break
            
        case .Last:
            rotation = 0.0
            position = self.maxPosition/2
            break
        }
        
        let factor = CGFloat(self.direction.rawValue * 2 - 1)
        //            let x = self.object.center.x
        
        print("cneter BEFROE: \(self.object.center.x)")
        print("targetPos \(self.object.center.x + position * factor)")
        
        UIView.animateWithDuration(duration, delay: wait, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            
            self.object.layer.position.x = self.object.center.x + position * factor
            self.object.transform = CGAffineTransformMakeRotation(rotation * factor)
            //            print("position: \(position * factor)")
            //            print("cneter: \(self.object.center.x) layer: \(self.object.layer.position.x)")
            
        }) {(finished) in
            
            self.direction = Direction(rawValue: abs(self.direction.rawValue - 1))!
            print("FINISHED cneter: \(self.object.center.x) layer: \(self.object.layer.position.x)\n\n")
            if self.counter < self.repetitions{
                self.state = .Middle
                self.shake()
                self.counter += 1
            }else if self.counter == self.repetitions{
                self.state = .Last
                self.shake()
                self.counter += 1
            }else{
                self.counter = 0
                //                self.direction = .Right
                self.state = .First
            }
            
        }
    }
}







//
//
//
//
//
//
////
////  CustomAnimation.swift
////  Makestagram
////
////  Created by Jake on 6/29/16.
////  Copyright © 2016 Make School. All rights reserved.
////
//
//import UIKit
//
//enum Direction: Int{
//    case Left, Right
//}
//enum State {
//    case First
//    case Middle
//    case Final
//}
//
//class CustomAnimation {
//
//    // MARK: - Properties
//    var view: UIView!
//    var delay: Double!
//    var repetitions: Int!
//    var maxRotation: CGFloat!
//    var maxPosition: CGFloat!
//    var duration: Double!
//
//    var animationDirection: Direction = .Left
//
//    var state: State = .First
//
//    var counter = 0
//
//    // MARK: - Initializers
//    init(view: UIView, delay: Double, direction: Direction, repetitions: Int, maxRotation: CGFloat, maxPosition: CGFloat, duration: Double) {
//        self.view = view
//        self.delay = delay
//        self.animationDirection = direction
//        self.repetitions = repetitions
//        self.maxRotation = maxRotation
//        self.maxPosition = maxPosition
//        self.duration = duration
//    }
//
//    // MARK: - Animation Methods
//    func shakeAnimation() {
//        UIView.animateWithDuration(self.duration, delay: self.delay, options: .TransitionNone, animations: {
//
//            var position = self.maxPosition
//            var rotation = self.maxRotation
//
//            switch self.state {
//            case .First:
//                position = self.maxPosition / 2
//                break
//            case .Middle:
//                break
//            case .Final:
//                rotation = 0
//                position = self.maxPosition / 2
//                break
//            }
//
//            // Factor
//            let factor = CGFloat(self.animationDirection.rawValue * 2 - 1)
//
//            //            print("position: \(position)")
//            //            print("center: \(self.view.center.x) layer: \(self.view.layer.position.x)")
//            //            print("targetPosition \(self.view.center.x + position * factor)")
//
//            // Position
//            let x = self.view.center.x + position * factor
//            self.view.layer.position.x = x
//
//            // Rotation
//            self.view.transform = CGAffineTransformMakeRotation(rotation * factor)
//
//        }) { (completed: Bool) in
//            self.finishAnimation()
//        }
//    }
//
//    //    func spinAnimation() {
//    //        UIView.animateWithDuration(self.duration, animations: {
//    //
//    //            var rotation = self.maxRotation
//    //
//    //            switch self.state {
//    //            case .First:
//    //                break
//    //            case .Middle:
//    //                break
//    //            case .Final:
//    //                rotation = 0
//    //                break
//    //            }
//    //            let factor = CGFloat(self.animationDirection.rawValue * 2 - 1)
//    //            self.view.transform = CGAffineTransformMakeRotation(360)
//    //        }) { (completed: Bool) in
//    //            self.spinAnimation()
//    //        }
//    //    }
//
//    // MARK: - Helper Methods
//    func finishAnimation() {
//        //        print("FINISHED center: \(self.view.center.x) layer: \(self.view.layer.position.x)\n\n\n\n")
//
//        self.animationDirection = Direction(rawValue: abs(self.animationDirection.rawValue - 1))!
//
//        if self.counter < self.repetitions {
//            self.state = .Middle
//            self.shakeAnimation()
//            self.counter += 1
//
//        } else if self.counter == self.repetitions {
//            self.state = .Final
//            self.shakeAnimation()
//            self.counter += 1
//
//        } else {
//            self.state = .First
//            self.counter = 0
//
//            if self.repetitions % 2 == 0 {
//                self.animationDirection =
//                    Direction(rawValue: abs(self.animationDirection.rawValue - 1))!
//            }
//        }
//
//    }
//
//}