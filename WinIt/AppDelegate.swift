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
        prepareTimer()
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
    
    func prepareTimer() {
        let requestURL: NSURL = NSURL(string: "http://www.timeapi.org/utc/now?format=%25Y-%25m-%25d%20%25I:%25M:%25S")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                let stringFormattedDate = String(data: data!, encoding: NSUTF8StringEncoding)
                let dateFormatter = NSDateFormatter()
                //        2016-07-09T04:34:04+01:00         http://www.timeapi.org/utc/now?\Y.\m.\d-\I:\M:\S%20
                //        2016.07.09-05:04:02
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"/* find out and place date format from http://userguide.icu-project.org/formatparse/datetime */
                print(String(stringFormattedDate))
                
                let date = dateFormatter.dateFromString(stringFormattedDate!)
                Global.timeOffset = (date?.timeIntervalSince1970)! - NSDate().timeIntervalSince1970
                print(Global.timeOffset)
                print(Global.getTimeStamp())
            }
        }
        
        task.resume()
    }
    
    // MARK: - Helper Methods
    func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        
        window?.rootViewController? = startViewController
        
    }
}

