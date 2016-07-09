//
//  AppDelegate.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    
    var startViewController: UIViewController!
    var welcomeViewController: WelcomeViewController!
    
    // MARK: - Initializers
    override init(){
        FIRApp.configure()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        prepareInitialViewController()
        prepareLoginNotificationObserver()
        prepareWindow()
        
        return true
    }
    
    // MARK: - Preparations
    func prepareWindow() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController
        self.window?.makeKeyAndVisible()
    }
    
    func prepareLoginNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.login), name: "Login", object: nil)
    }
    
    func prepareInitialViewController() {
        
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            
        } else {
            // No user is signed in.
            let storyboard = UIStoryboard(name: "SignupLogin", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNavigationController") as! UINavigationController
        }

    }
    
    // MARK: - Helper Methods
    func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        
        window?.rootViewController? = startViewController
        
    }
}

