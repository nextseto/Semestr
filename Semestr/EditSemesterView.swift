
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: EditSemesterView.swift
// Description: Displays a list of classes from collected semester data
// Last modified on: April 19, 2016

import UIKit
import CoreData

final class EditSemesterView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView! // The Table View instance for this View Controller
    
    var selectedSemester:Semester! // A Semester object instance
    
    //-----------------------------------------------------------------------------------------
    //
    //  Variable: coreData
    //
    //    Purpose: Bridges the database to the table view to show in this View Controller
    //
    //    Pre-condition: NSFetchedResultsControllerDelegate must be added to the View Controller
    //    Post-condition: This ViewController is initialized with Course objects with the query in its predicate
    //-----------------------------------------------------------------------------------------

    lazy var coreData: NSFetchedResultsController<NSFetchRequestResult> =
    {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Course") // Get all Course Objects
        fetch.sortDescriptors = [NSSortDescriptor(key: "day", ascending: true)] // Sort by Day
        fetch.predicate = NSPredicate(format: "semester.name == %@", self.selectedSemester.name!) // Find elements that are associated with the semester
        
        let control = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreData.app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        control.delegate = self
        return control
    }()
    
    
    /* ---- ViewController Code ---- */
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: viewDidLoad()
    //
    //    Parameters: None
    //
    //    Pre-condition: NSFetchedResultsControllerDelegate must be added to the View Controller
    //    Post-condition: This ViewController is initialized with the name of the Semester and data Course objects from the database
    //-----------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = selectedSemester.name
        
        do { try self.coreData.performFetch() }
        catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: didReceiveMemoryWarning()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: This cleans up the ViewController when iOS gives 'low-memory' warning
    //-----------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /* ---- NSFetchedResultsController Code ---- */
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: didChangeObject()
    //
    //    Parameters:
    //    controller NSFetchedResultsController; A NSFetchedResultsController object associated with the view
    //    anObject AnyObject; A core data object from the database
    //    indexPath NSIndexPath; A NSIndexPath object associated with the index of the cells in the table view
    //    type NSFetchedResultsChangeType; A enum which denotes changes that are made to the table view
    //    newIndexPath NSIndexPath; A NSIndexPath object associated with a new index of the cells in the table view (if applicable)
    //
    //    Pre-condition: NSFetchedResultsControllerDelegate must be added to the View Controller
    //    Post-condition: Updates the table view to be in sync with the database
    //-----------------------------------------------------------------------------------------
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type)
        {
            case .insert:
                if let indexPath = newIndexPath
                {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
            
            case .delete:
                if let indexPath = indexPath
                {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            
            default:
                print("Not Implemented - \(type)")
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: controllerWillChangeContent()
    //
    //    Parameters:
    //    controller NSFetchedResultsController; A tableview object associated with the view
    //
    //    Pre-condition: NSFetchedResultsControllerDelegate must be added to the View Controller
    //    Post-condition: Updates the table view to be in sync with the database
    //-----------------------------------------------------------------------------------------
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { tableView.beginUpdates() }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: controllerDidChangeContent()
    //
    //    Parameters:
    //    controller NSFetchedResultsController; A tableview object associated with the view
    //
    //    Pre-condition: NSFetchedResultsControllerDelegate must be added to the View Controller
    //    Post-condition: Updates the table view to be in sync with the database
    //-----------------------------------------------------------------------------------------
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { tableView.endUpdates() }
    
    
    /* ---- UITableView Code ---- */
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: didSelectRowAtIndexPath()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    indexPath NSIndexPath; A NSIndexPath object associated with the index of a tapped table view cell
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: De-highlights the cell and presents the 'EditCourseView' View Controller
    //-----------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        let view = storyboard!.instantiateViewController(withIdentifier: "EditCourseView") as! EditCourseView
        view.selectedCourse = coreData.object(at: indexPath) as! Course
        present(view, animated: true, completion: nil)
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: cellForRowAtIndexPath()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    indexPath NSIndexPath; A NSIndexPath object associated with the index of a tapped table view cell
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Adds a table cell into the table view with information for each cell
    //-----------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tablecell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        
        let temp = coreData.object(at: indexPath) as! Course
        tablecell.textLabel?.text = temp.name
        tablecell.detailTextLabel?.text = "\(temp.location!) \(temp.room!)"
        
        return tablecell
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: commitEditingStyle()
    //
    //    Parameters:
    //    editingStyle UITableViewCellEditingStyle; A tableview object associated with the view
    //    indexPath NSIndexPath; A NSIndexPath object associated with the index of a selected table view cell
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Deletes a cell from the table view and deletes the associated object in the database
    //-----------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            CoreData.app.deleteObject(coreData.object(at: indexPath) as! NSManagedObject)
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: numberOfSectionsInTableView()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the number of sections of Courses from the database
    //-----------------------------------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if let sections = coreData.sections
        {
            return sections.count
        }
            return 0
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: numberOfRowsInSection()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    section Int; A tableview object associated with the view
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the number of rows to populate the tableview from the number of objects in the database
    //-----------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = coreData.sections
        {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
            return 0
    }
}





