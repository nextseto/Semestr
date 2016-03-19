
// Developer: Warren Seto
//      File: Classes.swift
//   Purpose: A list of classes that this application will be using

import UIKit
import CoreData

/** A course has a: name, startTime, endTime, location, room and day. Each course has a day assigned to it. */
class Course: NSManagedObject
{
    @NSManaged var endTime: String?
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var room: String?
    @NSManaged var startTime: String?
    @NSManaged var imageName: String?
    
    @NSManaged var day: Day?
    
    
}

/** A Day has a: name, index (of the week), courses and is associated to a specific semester. Each Day has many courses.*/
class Day: NSManagedObject
{
    @NSManaged var index: Int16
    @NSManaged var name: String?
    @NSManaged var courses: NSSet?
    
    @NSManaged var semester: Semester?
    
}

/** A Semester has a: name, and specific days associated to it.*/
class Semester: NSManagedObject
{
    @NSManaged var name: String?
    @NSManaged var imported: Bool
    
    @NSManaged var days: NSSet?
    
    
}

extension CoreData
{
    internal func addNewSemester(inputName:String)
    {
        let tempSemester:Semester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: self.managedObjectContext) as! Semester
        tempSemester.name = inputName
        tempSemester.imported = false
        
        save()
    }
    
    internal func getAllSemesters() -> [Semester]
    {
        do
        {
            return try self.managedObjectContext.executeFetchRequest(NSFetchRequest(entityName: "Semester")) as! [Semester]
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    
    
    
    
    
    
}