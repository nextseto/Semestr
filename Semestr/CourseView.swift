
// Developer: Warren Seto
//      File: CourseView.swift
//   Purpose: Displays various classes for each day in a semester

import UIKit
import CoreData

final class CourseView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate
{
    
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView!
    
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var today = ""
    var day = 0
    
    lazy var coreData: NSFetchedResultsController =
        {
            let fetch = NSFetchRequest(entityName: "Course") // Get all Course Objects
            fetch.sortDescriptors = [NSSortDescriptor(key: "day", ascending: true)] // Sort by Day
            fetch.predicate = NSPredicate(format: "day = '\(self.today)' AND semester.selected == true") // Find elements that are associated with the semester
            
            let control = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreData.app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            control.delegate = self
            return control
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let format = NSDateFormatter()
        format.dateFormat = "EEEE"
        today = format.stringFromDate(NSDate())
        title = today
        
        day = days.indexOf(today)!
    }
    
    override func viewDidAppear(animated: Bool)
    {
        do
        {
            try coreData.performFetch()
            tableView.reloadData()
        }
            
        catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
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
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Right)
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
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Left)
            }
                
            catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
        }
    }
    
    
    /* ---- NSFetchedResultsController Code ---- */
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        switch (type)
        {
        case .Insert:
            if let indexPath = newIndexPath
            {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath
            {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
        default:
            print("Not Implemented - \(type)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) { tableView.beginUpdates() }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) { tableView.endUpdates() }
    
    
    /* ---- UITableView Code ---- */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablecell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CourseCell")!
        
        let temp = coreData.objectAtIndexPath(indexPath) as! Course
        tablecell.textLabel?.text = temp.name
        tablecell.detailTextLabel?.text = "\(temp.location!) \(temp.room!)"
        //tablecell.imageView?.image = UIImage(named: "FORCINA")
        
        return tablecell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (editingStyle == .Delete)
        {
            CoreData.app.deleteObject(coreData.objectAtIndexPath(indexPath) as! NSManagedObject)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if let sections = coreData.sections
        {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = coreData.sections
        {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

