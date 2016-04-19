
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: SettingView.swift
// Description: Displays a page to configure settings for the application
// Last modified on: April 19, 2016

import UIKit

final class SettingView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    /* ---- Variables ---- */
    
    let headerText:[String] = ["Schedule", "Feedback", ""],
        mainText:[[String]] = [["All Semester", "Add Semester"], ["Send Feedback", "Please Rate Semestr"], ["About"]],
        footerText:[String] = ["", "Semestr will never interrupt you for ratings.", ""]
    
    /* ---- ViewController Code ---- */
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: viewDidLoad()
    //
    //    Parameters: None
    //
    //    Pre-condition: None
    //    Post-condition: This ViewController is initialized
    //-----------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: closeViewController()
    //
    //    Parameters:
    //    sender AnyObject; An instance of a generic object that called the function
    //
    //    Pre-condition: None
    //    Post-condition: Closes and de-allocates the current view controller
    //-----------------------------------------------------------------------------------------
    
    @IBAction func closeViewController(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    //    Post-condition: De-highlights the cell and presents the other View Controllers
    //-----------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch (indexPath.section)
        {
            case 0:
                if (indexPath.row == 0)
                {
                    navigationController?.pushViewController(storyboard.instantiateViewControllerWithIdentifier("SemesterView"), animated: true)
                }
                else
                {
                    print("Add Semester")
                    
                    navigationController?.pushViewController(storyboard.instantiateViewControllerWithIdentifier("SelectNewView"), animated: true)
                    //CoreData.app.addNewSemester("Spring 201\(arc4random_uniform(9) + 0)")
                    
                }
            case 1:
                if (indexPath.row == 0)
                {
                    print("Send Feedback")
                }
                else
                {
                    print("Please Rate Semestr")
                }
            case 2:
                print("About")

            default: break
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
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("nameCell")!
        
        cell.textLabel?.text = mainText[indexPath.section][indexPath.row]
        
        return cell
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return headerText[section]}
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: titleForFooterInSection()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //    section Int; An index of a tapped table view cell
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the name of a footer for a section to the TableView Controller
    //-----------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? { return footerText[section] }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: numberOfSectionsInTableView()
    //
    //    Parameters:
    //    tableView UITableView; A tableview object associated with the view
    //
    //    Pre-condition: UITableViewDataSource must be added to the View Controller UITableViewDelegate
    //    Post-condition: Returns the number of sections of Courses from an array
    //-----------------------------------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return mainText.count }
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return mainText[section].count }
}

