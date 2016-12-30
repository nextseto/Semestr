
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: AppDelegate.swift
// Description: The starting point of the application. Similar to 'int main()' in C++
// Last modified on: April 19, 2016

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    //-----------------------------------------------------------------------------------------
    //
    //  Function: didFinishLaunchingWithOptions()
    //
    //    Parameters:
    //    application UIApplication; The UIApplication instance of this application.
    //
    //    Pre-condition: None
    //    Post-condition: An override point for customization after application launch. Since there is no custom code, it just returns true and lets the application continue.
    //-----------------------------------------------------------------------------------------
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {

        return true
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: applicationWillResignActive()
    //
    //    Parameters:
    //    application UIApplication; The UIApplication instance of this application.
    //
    //    Pre-condition: None
    //    Post-condition: Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    //-----------------------------------------------------------------------------------------

    func applicationWillResignActive(_ application: UIApplication)
    {

    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: applicationDidEnterBackground()
    //
    //    Parameters:
    //    application UIApplication; The UIApplication instance of this application.
    //
    //    Pre-condition: None
    //    Post-condition: Releases shared resources, save user data, invalidate timers, and store enough application state information to restore the application to its current state in case it is terminated later.
    //-----------------------------------------------------------------------------------------

    func applicationDidEnterBackground(_ application: UIApplication)
    {

    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: applicationWillEnterForeground()
    //
    //    Parameters:
    //    application UIApplication; The UIApplication instance of this application.
    //
    //    Pre-condition: None
    //    Post-condition: Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //-----------------------------------------------------------------------------------------

    func applicationWillEnterForeground(_ application: UIApplication)
    {

    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: applicationDidBecomeActive()
    //
    //    Parameters:
    //    application UIApplication; The UIApplication instance of this application.
    //
    //    Pre-condition: None
    //    Post-condition: Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //-----------------------------------------------------------------------------------------

    func applicationDidBecomeActive(_ application: UIApplication)
    {

    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: applicationWillTerminate()
    //
    //    Parameters:
    //    application UIApplication; The UIApplication instance of this application.
    //
    //    Pre-condition: None
    //    Post-condition: Called when the application is about to terminate. Save data if appropriate. Saves changes in the application's managed object context before the application terminates.
    //-----------------------------------------------------------------------------------------

    func applicationWillTerminate(_ application: UIApplication)
    {
        CoreData.app.save()
    }
}

