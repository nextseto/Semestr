
// Developer: Warren Seto
//      File: SemesterView.swift
//   Purpose: Displays a list of all semesters

import UIKit
import CoreData

final class SemesterView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView!
    
    var flag = false
    
    lazy var coreData: NSFetchedResultsController =
    {
        let fetch = NSFetchRequest(entityName: "Semester") // Get all Semester Objects
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)] // Sort objects by their name
        
        let control = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreData.app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        control.delegate = self
        return control
    }()
    
    
    /* ---- ViewController Code ---- */
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        do { try self.coreData.performFetch() }
        catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
        
        
    }
    
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
    
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    
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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) { tableView.beginUpdates() }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) { tableView.endUpdates() }
    
    
    /* ---- UITableView Code ---- */
    
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
            //tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .DisclosureIndicator
            
            let view = storyboard!.instantiateViewControllerWithIdentifier("EditSemesterView") as! EditSemesterView
            view.selectedSemester = temp
            navigationController?.pushViewController(view, animated: true)
        }
    }
    
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (section == 0)
        {
            return "My Semesters"
        }
            return "Friend's Semesters"
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
}

