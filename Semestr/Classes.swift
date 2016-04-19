
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: Classes.swift
// Description: A list of classes that this application will be using
// Last modified on: April 19, 2016

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
    @NSManaged var selected: Bool
    @NSManaged var imported: Bool
    
    @NSManaged var courses: NSSet?
}

extension CoreData
{
    //-----------------------------------------------------------------------------------------
    //
    //  Function: addNewSemester()
    //
    //    Parameters:
    //    inputName String; the name of a semester
    //
    //    Pre-condition: None
    //    Post-condition: A 'Semester' object is made and saved into the database
    //-----------------------------------------------------------------------------------------
    
    internal func addNewSemester(inputName:String)
    {
        let tempSemester:Semester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: self.managedObjectContext) as! Semester
        tempSemester.name = inputName
        tempSemester.imported = false
        
        save()
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: addNewCourse()
    //
    //    Parameters:
    //    semester Semester; an 'Semester' object
    //    inputName String; the name of a course
    //    inputLocation String; the location of a course
    //    inputRoom String; the room of a course
    //    inputImageName String; the image location of a course
    //    inputStartTime String; the start time of a course
    //    inputEndTime String; the end time of a course
    //    inputDay String; the day of a course
    //
    //    Pre-condition: A semester should already be in the database before adding a new course
    //    Post-condition: A 'Course' object is made and saved into the database
    //-----------------------------------------------------------------------------------------
    
    internal func addNewCourse(semester semester:Semester, _  inputName:String, _  inputLocation:String, _  inputRoom:String, _ inputImageName:String, _ inputStartTime:String, _ inputEndTime:String, _ inputDay:String)
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
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: getAllSemesters()
    //
    //    Parameters: None
    //
    //    Pre-condition: There should be Semester objects already in the database
    //    Post-condition: An array 'Semester' objects are returned
    //-----------------------------------------------------------------------------------------
    
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
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: getSemester()
    //
    //    Parameters:
    //    inputSemesterName String; the name of a semester to find
    //
    //    Pre-condition: There should be Semester objects already in the database
    //    Post-condition: A 'Semester' objects is returned to the user
    //-----------------------------------------------------------------------------------------
    
    internal func getSemester(inputSemesterName:String) -> Semester
    {
        do
        {
            let fetch = NSFetchRequest(entityName: "Semester") // Get all Semester Objects
            fetch.predicate = NSPredicate(format: "name == '\(inputSemesterName)'") // Find elements that are associated with the semester
            
            return try self.managedObjectContext.executeFetchRequest(fetch).first as! Semester
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
            return Semester()
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: deleteObject()
    //
    //    Parameters:
    //    inputObject NSManagedObject; A general object that should be deleted in the database
    //
    //    Pre-condition: There should be Semester objects already in the database
    //    Post-condition: The object is deleted in the database
    //-----------------------------------------------------------------------------------------
    
    internal func deleteObject(inputObject:NSManagedObject)
    {
        managedObjectContext.deleteObject(inputObject)
        save()
    }
}