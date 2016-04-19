
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: CoreData.swift
// Description: Standard Singleton that manages the communication between SQLite and the Core Data stack
// Last modified on: April 19, 2016

import UIKit
import CoreData


public final class CoreData 
{
    /** Application's Main CoreData Instance (Singleton) */
    static let app = CoreData()
    
    internal lazy var applicationDocumentsDirectory: NSURL =
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    internal lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = NSBundle.mainBundle().URLForResource("Semestr", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    internal lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator =
    {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        
        do { try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil) }
        catch
        {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    internal lazy var managedObjectContext: NSManagedObjectContext =
    {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()

    //-----------------------------------------------------------------------------------------
    //
    //  Function: save()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: Any changes to the database will be saved. Akin to COMMIT
    //-----------------------------------------------------------------------------------------
    
    internal func save()
    {
        if managedObjectContext.hasChanges
        {
            do { try managedObjectContext.save() }
            catch
            {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}