
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: SemesterView.swift
// Description: Displays a list of all semesters from courses in the database
// Last modified on: April 19, 2016

import UIKit
import CoreData

final class SemesterView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView! // The Table View instance for this View Controller
    
    var flag = false
    
    //-----------------------------------------------------------------------------------------
    //
    //  Variable: coreData
    //
    //    Purpose: Bridges the database to the table view to show in this View Controller
    //
    //    Pre-condition: NSFetchedResultsControllerDelegate must be added to the View Controller
    //    Post-condition: This ViewController is initialized with Course objects with the query in its predicate
    //-----------------------------------------------------------------------------------------
    
    lazy var coreData: NSFetchedResultsController =
    {
        let fetch = NSFetchRequest(entityName: "Semester") // Get all Semester Objects
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)] // Sort objects by their name
        
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
    //    Pre-condition: None
    //    Post-condition: This ViewController is initialized with data from the database.
    //-----------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        do { try self.coreData.performFetch() }
        catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
        
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: save()
    //
    //    Parameters:
    //    sender AnyObject; An instance of a generic object that called the function
    //
    //    Pre-condition: None
    //    Post-condition: Changes the navigation bar button from "Done" to "Edit" when tapped
    //-----------------------------------------------------------------------------------------
    
    @IBAction func toggleEdit(sender: AnyObject)
    {
        flag = !flag
        toggleEditMode()
        
        if flag
        {
            (sender as! UIBarButtonItem).title = "Done"
            (sender as! UIBarButtonItem).style = .Done
        }
        
        else
        {
            (sender as! UIBarButtonItem).title = "Edit"
            (sender as! UIBarButtonItem).style = .Plain
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: toggleEditMode()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: Changes all the table view cells with the appropriate accessory items
    //-----------------------------------------------------------------------------------------
    
    func toggleEditMode()
    {
        tableView.beginUpdates()
        
        for rowIndex in tableView.indexPathsForVisibleRows!
        {
            let cell = tableView.cellForRowAtIndexPath(rowIndex)
            
            if flag
            {
                cell!.accessoryType = .DisclosureIndicator
            }
                
            else
            {
                if ((coreData.objectAtIndexPath(rowIndex) as! Semester)).selected
                {
                    cell?.accessoryType = .Checkmark
                }
                    
                else
                {
                    cell?.accessoryType = .None
                }
            }
        }
        
        tableView.endUpdates()
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
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        switch (type)
        {
            case .Insert:
                if let indexPath = newIndexPath
                {
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            
            case .Update:
                if let indexPath = indexPath
                {
                    if !flag
                    {
                        if ((coreData.objectAtIndexPath(indexPath) as! Semester)).selected
                        {
                            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
                        }
                            
                        else
                        {
                            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
                        }
                    }
                }
            
            case .Delete:
                if let indexPath = indexPath
                {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            
            default: break
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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) { tableView.beginUpdates() }
    
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
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) { tableView.endUpdates() }
    
    
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
    //    Post-condition: De-highlights the cell
    //-----------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let temp = coreData.objectAtIndexPath(indexPath) as! Semester
        
        if !flag
        {
            temp.selected = !temp.selected
            CoreData.app.save()
        }
            
        else
        {
            let view = storyboard!.instantiateViewControllerWithIdentifier("EditSemesterView") as! EditSemesterView
            view.selectedSemester = temp
            navigationController?.pushViewController(view, animated: true)
        }
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablecell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SemesterCell")!
        
        let temp = coreData.objectAtIndexPath(indexPath) as! Semester
        
        tablecell.textLabel?.text = temp.name
        
        if flag
        {
            tablecell.accessoryType = .DisclosureIndicator
        }
            
        else if temp.selected
        {
            tablecell.accessoryType = .Checkmark
        }
            
        else
        {
            tablecell.accessoryType = .None
        }
        
        return tablecell
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: titleForHeaderInSection()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    section Int; An index of a tapped table view cell
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the name of a header for a section to the TableView Controller
    //-----------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (section == 0)
        {
            return "My Semesters"
        }
            return "Friend's Semesters"
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (editingStyle == .Delete)
        {
            CoreData.app.deleteObject(coreData.objectAtIndexPath(indexPath) as! NSManagedObject)
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = coreData.sections
        {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
            return 0
    }
}

