
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: CourseView.swift
// Description: Displays various classes for each day in a semester
// Last modified on: April 19, 2016

import UIKit
import CoreData

final class CourseView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate
{
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView! // The Table View instance for this View Controller
    
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var today = ""
    var day = 0
    
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
            fetch.predicate = NSPredicate(format: "day = '\(self.today)' AND semester.selected == true") // Find elements that are associated with the semester
            
            let control = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreData.app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            control.delegate = self
            return control
    }()
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: viewDidLoad()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: This ViewController is initialized with the name of today
    //-----------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        today = format.string(from: Date())
        title = today
        
        day = days.index(of: today)!
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: viewDidAppear()
    //
    //    Parameters:
    //    animated Bool; Toggles if the view should animate when appears
    //
    //    Pre-condition: None
    //    Post-condition: Syncs the database with this ViewController
    //-----------------------------------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool)
    {
        do
        {
            try coreData.performFetch()
            tableView.reloadData()
        }
            
        catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: scrollViewDidEndDragging()
    //
    //    Parameters:
    //    scrollView UIScrollView; A UIScrollView instance of the view that is being scrolled
    //    decelerate Bool; Indicates when the view stops scrolling
    //
    //    Pre-condition: None
    //    Post-condition: Allows the user to scroll between the days of the week and updates the view accordingly
    //-----------------------------------------------------------------------------------------
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let distance = abs(scrollView.contentOffset.x)
        
        if (scrollView.contentOffset.x < 0 && distance >= 47)
        {
            if (day == 0) { day = 6 }
            else { day -= 1 }
            title = days[day]
            
            do
            {
                coreData.fetchRequest.predicate = NSPredicate(format: "day = '\(days[day])' AND semester.selected == true")
                try coreData.performFetch()
                tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.right)
            }
                
            catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
        }
            
        else if (scrollView.contentOffset.x > 0 && distance >= 47)
        {
            day = (day + 1) % 7
            title = days[day]
            
            do
            {
                coreData.fetchRequest.predicate = NSPredicate(format: "day = '\(days[day])' AND semester.selected == true")
                try coreData.performFetch()
                tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.left)
            }
                
            catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
        }
    }
    
    
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
    //    Post-condition: De-highlights the cell
    //-----------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
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
        
        if (temp.location?.contains("Armstrong") == true)
        {
            tablecell.imageView?.image = UIImage(named: "Armstrong")
        }
            
        else if (temp.location?.contains("Forcina") == true)
        {
            tablecell.imageView?.image = UIImage(named: "Forcina")
        }
            
        else
        {
            tablecell.imageView?.image = UIImage(named: "default")
        }
        
        let rect = UIView(frame: CGRect(x: view.frame.width - 89, y: tablecell.frame.height * 0.6, width: 80, height: 27))
        rect.layer.cornerRadius = 12
        
        let label = UILabel(frame: CGRect(x: view.frame.width - 91, y: tablecell.frame.height * 0.6, width: 85, height: 27))
        label.font = UIFont(name: "Arial", size: 10.0)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Ends: \((temp.startTime?.components(separatedBy: " ").last)!)"

        return tablecell
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
}

