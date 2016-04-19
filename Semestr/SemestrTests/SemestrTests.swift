
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: SemesterTest.swift
// Description: Test code to make sure the database works as expected
// Last modified on: April 19, 2016

// Note: All tests should be done with XCode's testing framework installed.

import XCTest
import CoreData

@testable import Semestr

class SemestrTests: XCTestCase
{
    var tempSemester:Semester!
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: setUp()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: Adds and updates the database with a new temporary semester called "[Test Semester]"
    //-----------------------------------------------------------------------------------------
    
    override func setUp()
    {
        super.setUp()

        let newSemester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: CoreData.app.managedObjectContext)
        newSemester.setValue("[Test Semester]", forKey: "name")
        newSemester.setValue(true, forKey: "imported")
        
        CoreData.app.save()
        
        do
        {
            let fetch = NSFetchRequest(entityName: "Semester") // Get all Semester Objects
            fetch.predicate = NSPredicate(format: "name == '[Test Semester]'") // Find elements that are associated with the semester
            
            tempSemester = try CoreData.app.managedObjectContext.executeFetchRequest(fetch).first as! Semester
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: tearDown()
    //
    //    Parameters: None
    //
    //    Pre-condition: The variable 'tempSemester' instance and other course objects are initalized
    //    Post-condition: Removes the newly created temporary semester named "[Test Semester]"
    //-----------------------------------------------------------------------------------------
    
    override func tearDown()
    {
        super.tearDown()
        
        CoreData.app.deleteObject(tempSemester)
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: testExample()
    //
    //    Parameters: None
    //
    //    Pre-condition: The variable 'tempSemester' instance is initalized
    //    Post-condition: XCTAssert and related functions to verify the tests to produce the correct results.
    //-----------------------------------------------------------------------------------------
    
    func testExample()
    {
        //Test the semester entry by checking a boolean of the object
        do
        {
            let fetch = NSFetchRequest(entityName: "Semester") // Get all Semester Objects
            fetch.predicate = NSPredicate(format: "name == '[Test Semester]'") // Find elements that are associated with the semester
            
            let aSemester = try CoreData.app.managedObjectContext.executeFetchRequest(fetch).first
            XCTAssertEqual(aSemester!.imported, true, "the object should have the same String values")
            
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // Test Adding Courses
        CoreData.app.addNewCourse(semester: tempSemester, "CSC 215", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Monday")
        CoreData.app.addNewCourse(semester: tempSemester, "CSC 315", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Tuesday")
        CoreData.app.addNewCourse(semester: tempSemester, "CSC 415", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Wednesday")
        CoreData.app.addNewCourse(semester: tempSemester, "CSC 515", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Thursday")
        CoreData.app.addNewCourse(semester: tempSemester, "CSC 615", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Friday")
        CoreData.app.addNewCourse(semester: tempSemester, "CSC 715", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Saturday")
        
        //Test fifth course to check if it was entered into the database
        let allCourses = CoreData.app.getSemester("[Test Semester]").courses?.allObjects as! [Course]
        XCTAssertEqual(allCourses.first?.semester?.name, "[Test Semester]", "the object should have the same String values")
    }
    
}
