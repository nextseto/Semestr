
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
    /** Core Data Singleton Instance. An entry point to use the Core Data Stack */
    static let app = CoreData()
    
    /** Main Core Data variable to access data */
    lazy var managedObjectContext: NSManagedObjectContext =
    {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType),
            context = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "Semestr", withExtension: "momd")!)!),
            storeURL = URL(string: "SingleViewCoreData.sqlite", relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
            
        do
        {
            try context.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        }
        catch let err as NSError
        {
            print("Could not perform operation: \(err), \(err.userInfo)")
            abort()
        }
        
        managedObjectContext.persistentStoreCoordinator = context
        return managedObjectContext
    }()
    
    /** Core Data save function. Essentially serves as a COMMIT */
    internal func save()
    {
        if managedObjectContext.hasChanges
        {
            do
            {
                try managedObjectContext.save()
            }
            catch let err as NSError
            {
                print("Could not save: \(err), \(err.userInfo)")
                abort()
            }
        }
    }
}
