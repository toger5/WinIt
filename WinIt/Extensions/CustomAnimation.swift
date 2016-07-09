//
//  CustomAnimation.swift
//  Makestagram
//
//  Created by Jake on 6/29/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

// MARK: - Enumerations
enum Direction: Int {
    case Left
    case Right
}

enum State {
    case First
    case Middle
    case Final
}

class CustomAnimation {
    
    // MARK: - Properties
    var view: UIView!
    var delay: Double!
    var repetitions: Int!
    var maxRotation: CGFloat!
    var maxPosition: CGFloat!
    var duration: Double!
    
    var running = false
    
    var direction: Direction = .Left
    
    var state: State = .First
    
    var counter = 0
    
    // MARK: - Initializers
    init(view: UIView, delay: Double, direction: Direction, repetitions: Int, maxRotation: CGFloat, maxPosition: CGFloat, duration: Double) {
        self.view = view
        self.delay = delay
        self.direction = direction
        self.repetitions = repetitions
        self.maxRotation = maxRotation
        self.maxPosition = maxPosition
        self.duration = duration
    }
    
    // MARK: - Animation Methods
    func rotateAnimation() {
        let factor = CGFloat(self.direction.rawValue * 2 - 1)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        
        // Rotate to the Right
        rotateAnimation.toValue = CGFloat(M_PI * Double(self.maxRotation) * 2.0)
        
        // Rotate to the Left
        //        rotateAnimation.toValue = CGFloat(M_PI * 4.0 * Double(factor))
        
        rotateAnimation.duration = self.duration
        self.view.layer.addAnimation(rotateAnimation, forKey: nil)
        
        self.maxRotation = self.maxRotation * factor
    }
    
    func bubble() {
        view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        UIView.animateWithDuration(2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.20,
                                   initialSpringVelocity: 6.00,
                                   options: .AllowUserInteraction,
                                   animations: {
                                    self.view.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func spring() {
        UIView.animateWithDuration(2.0, delay: 0.0,
                                   usingSpringWithDamping: 0.25,
                                   initialSpringVelocity: 0.0,
                                   options: [],
                                   animations: {
                                    self.view.layer.position.x += 200.0
                                    self.view.layer.cornerRadius = 50.0
                                    self.view.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
            }, completion: nil)
    }
    
    
    func shakeAnimation() {
        
        guard !running else {
            return
        }
        
        running = true
        
        let factor = CGFloat(direction.rawValue * 2 - 1)
        
        var position = maxPosition
        var rotation = maxRotation
        
        switch self.state {
        case .First:
            position = maxPosition / 2
            break
        case .Middle:
            break
        case .Final:
            rotation = 0
            position = maxPosition / 2
            break
        }
        
        UIView.animateWithDuration(self.duration,
                                   delay: self.delay,
                                   options: .TransitionNone,
                                   animations: {
                                    
                                    // Position
                                    let x = self.view.center.x + position * factor
                                    self.view.center.x = x
                                    
                                    // Rotation
                                    self.view.transform = CGAffineTransformMakeRotation(rotation * factor)
                                    
        }) { (completed: Bool) in
            self.running = false
            self.finishAnimation()
        }
        
    }
    
    func flyFromLeft() {
        
        //        UIView.animateWithDuration(self.duration, delay: self.delay, options: .CurveEaseIn, animations: {
        //
        //            let x = self.view.center.x + self.maxPosition * self.factor
        //            self.view.layer.position.x = x
        //
        //        }) { (completed: Bool) in
        //
        //            for self.counter in 0...3 {
        //                self.counter += 1
        //                self.flyIn()
        //            }
        //        }
        
    }
    
}

private extension CustomAnimation {
    // MARK: - Private Helper Methods
    func finishAnimation() {
        direction = Direction(rawValue: abs(self.direction.rawValue - 1))!
        
        if counter < self.repetitions {
            state = .Middle
            shakeAnimation()
            counter += 1
            
        } else if counter == repetitions {
            state = .Final
            shakeAnimation()
            counter += 1
            
        } else {
            state = .First
            counter = 0
            
            if repetitions % 2 == 0 {
                direction = Direction(rawValue: abs(self.direction.rawValue - 1))!
            }
        }
        
    }
}
