
// Developer: Warren Seto
//      File: AppDelegate.swift
//   Purpose: The starting point of the application

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        
        
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {

    }

    func applicationDidEnterBackground(application: UIApplication)
    {

    }

    func applicationWillEnterForeground(application: UIApplication)
    {

    }

    func applicationDidBecomeActive(application: UIApplication)
    {

    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreData.app.save()
    }

}

