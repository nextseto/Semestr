
// Developer: Warren Seto
//      File: Classes.swift
//   Purpose: A list of classes that this application will be using

import Foundation
import CoreData

/** A course has a: name, startTime, endTime, location, room and day. Each course has a day assigned to it. */
class Course: NSManagedObject
{
    @NSManaged var name: String?
    @NSManaged var startTime: String?
    @NSManaged var endTime: String?
    @NSManaged var location: String?
    @NSManaged var room: String?
    @NSManaged var day: NSManagedObject?
    
    
}

/** A Day has a: name, index (of the week), courses and is associated to a specific semester. Each Day has many courses.*/
class Day: NSManagedObject
{
    @NSManaged var name: String?
    @NSManaged var index: NSNumber?
    @NSManaged var courses: NSSet?
    @NSManaged var semester: NSManagedObject?
    
    
}

/** A Semester has a: name, and specific days associated to it.*/
class Semester: NSManagedObject
{
    @NSManaged var name: String?
    @NSManaged var days: NSSet?
    
    
}