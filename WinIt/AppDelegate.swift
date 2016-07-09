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
    
    var window: UIWindow?
    override init(){
        FIRApp.configure()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //        let dateFormatter = NSDateFormatter()
        //        2016-07-09T04:34:04+01:00         http://www.timeapi.org/utc/now?\Y.\m.\d-\I:\M:\S%20
        //        2016.07.09-05:04:02
        //        dateFormatter.dateFormat = "yyyy.MM.dd-HH:mm:ss"/* find out and place date format from http://userguide.icu-project.org/formatparse/datetime */
        //        let date = dateFormatter.dateFromString(/*your_date_string*/)
        
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
        //        let sroryboard = NSBundle.mainBundle().
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

