
// Developer: Warren Seto
//      File: Classes.swift
//   Purpose: A list of classes that this application will be using

import UIKit
import CoreData

/** A course has a: name, startTime, endTime, location, room and day. Each course has a day assigned to it. */
class Course: NSManagedObject
{
    @NSManaged var name: String?
    @NSManaged var location: String?
    @NSManaged var room: String?
    @NSManaged var imageName: String?
    @NSManaged var startTime: String?
    @NSManaged var endTime: String?
    @NSManaged var day: String?
    
    @NSManaged var semester: Semester?

    
}

/** A Semester has a: name, and specific days associated to it.*/
class Semester: NSManagedObject
{
    @NSManaged var name: String?
    @NSManaged var imported: Bool
    @NSManaged var courses: NSSet?
    
    
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
    
    internal func addNewCourse( semester semester:Semester, _  inputName:String, _  inputLocation:String, _  inputRoom:String, _ inputImageName:String, _ inputStartTime:String, _ inputEndTime:String, _ inputDay:String)
    {
        let tempCourse:Course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: self.managedObjectContext) as! Course
        
        tempCourse.name = inputName
        tempCourse.location = inputLocation
        tempCourse.room = inputRoom
        tempCourse.imageName = inputImageName
        tempCourse.startTime = inputStartTime
        tempCourse.endTime = inputEndTime
        tempCourse.day = inputDay
        tempCourse.semester = semester
        
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
    
    internal func deleteObject(inputObject:NSManagedObject)
    {
        managedObjectContext.deleteObject(inputObject)
        save()
    }
    
    
    
    
    
    
    
}