
// Developer: Warren Seto
//      File: CoreData.swift
//   Purpose: Standard Singleton that manages the Core Data stack

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
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do { try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil) }
        catch
        {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    internal lazy var managedObjectContext: NSManagedObjectContext =
    {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    /** Saves all objects that are stored in Core Data */
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